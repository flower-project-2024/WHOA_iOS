//
//  FlowerSearchViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/17/24.
//

import UIKit

class FlowerSearchViewController: UIViewController {
    // MARK: - Views
    lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FlowerSearchResultCell.self, forCellReuseIdentifier: FlowerSearchResultCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "어떤 꽃을 찾으시나요?"
        searchBar.searchBarStyle = .minimal
        searchBar.frame.size.width = searchBar.bounds.width
        searchBar.delegate = self
//        searchBar.autocorrectionType = .no
//        searchBar.spellCheckingType = .no
        searchBar.searchTextField.autocorrectionType = .no
        searchBar.searchTextField.spellCheckingType = .no
        return searchBar
    }()
    
    // MARK: - Properties
//    lazy var searchController: UISearchController = {
//        let sc = UISearchController(searchResultsController: nil)
//        sc.searchBar.placeholder = "어떤 꽃을 찾으시나요?"
//        sc.obscuresBackgroundDuringPresentation = true  // 사용자가 입력 중 배경을 어둡게 할지
//        sc.searchResultsUpdater = self  // UISearchResultUpdating 프로토콜 사용위함
//        return sc
//    }()
    
    lazy var filteredItems: [String] = []
    let tempData: [String] = [
        "히아신스", "아네모네", "아마란서스", "아마릴리스", "아이리스", "장미", "튤립", "그냥 꽃"
//        "hello", "chocolate", "jeju", "beer", "laptop", "iPhone", "coffee"
    ]
    private var isFiltering: Bool = false
    private var searchedText: String = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.titleView = searchBar
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        
        addViews()
        setupConstraints()
    }
    
    // MARK: - Helpers
    private func addViews(){
        view.addSubview(searchTableView)
    }
    
    private func setupConstraints(){
        searchTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Extension; TableView
extension FlowerSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteredItems.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FlowerSearchResultCell.identifier, for: indexPath) as! FlowerSearchResultCell
        
        // 검색 중이고 필터링된 내용이 있을 때만
        if isFiltering && !filteredItems.isEmpty {
            let filteredText = filteredItems[indexPath.row]
            print("filtered: \(filteredText)")
            
            let attributeString = NSMutableAttributedString(string: filteredText)
            
            /* 검색된 텍스트와 일치하는 부분 다른 색으로 처리 */
            var textFirstIndex: Int = 0  // 검색중인 키워드가 가장 처음 나온 인덱스
            
            // 검색 중인 키워드가 가장 처음으로 일치하는 문자열의 범위 구하기
            if let textFirstRange = filteredText.range(of: "\(searchedText)", options: .caseInsensitive) {
                // 거리(인덱스) 구해서 저장
                textFirstIndex = filteredText.distance(from: filteredText.startIndex, to: textFirstRange.lowerBound)
                
                attributeString.addAttribute(.foregroundColor, value: UIColor(red: 46/255, green: 225/255, blue: 176/255, alpha: 1), range: NSRange(location: textFirstIndex, length: searchedText.count))
                //cell.resultLabel.attributedText = attributeString
                cell.resultLabel.attributedText = attributeString
            }
        }
        
        return cell
    }
}

// MARK: - Extension; Search
extension FlowerSearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isFiltering = true
        self.searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedText = searchBar.text ?? ""
        print("Searched Text: \(searchedText)")
        self.filteredItems = self.tempData.filter { $0.localizedCaseInsensitiveContains(searchedText) }
        print("Filtered Items: \(filteredItems)")
        self.searchTableView.reloadData()
    }
}
