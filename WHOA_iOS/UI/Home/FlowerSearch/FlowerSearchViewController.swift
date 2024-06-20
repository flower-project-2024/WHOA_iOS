//
//  FlowerSearchViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/17/24.
//

import UIKit

class FlowerSearchViewController: UIViewController {
    // MARK: - Views
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FlowerSearchResultCell.self, forCellReuseIdentifier: FlowerSearchResultCell.identifier)
        tableView.register(NoSearchResultCell.self, forCellReuseIdentifier: NoSearchResultCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        //searchBar.placeholder = "어떤 꽃을 찾으시나요?"
        //searchBar.searchTextField.font = UIFont(name: "Pretendard-Regular", size: 14)
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.layer.cornerRadius = 19
        searchBar.searchTextField.layer.borderColor = UIColor.gray04.cgColor
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.frame.size.width = searchBar.bounds.width
        searchBar.searchTextField.frame.size = searchBar.frame.size
        searchBar.setImage(UIImage.searchIcon, for: .search, state: .normal)
        searchBar.setImage(UIImage.searchCancel, for: .clear, state: .normal)
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            if let font = UIFont(name: "Pretendard-Regular", size: 14) {
                let placeholderAttributedText =  NSAttributedString(string: "어떤 꽃을 찾으시나요?",
                                                         attributes: [NSAttributedString.Key.font: font])
                
                let attributes =  [NSAttributedString.Key.font: font] as [NSAttributedString.Key: Any]
                
                textField.attributedPlaceholder = placeholderAttributedText
                textField.font = font
                textField.textColor = UIColor.gray08
                textField.defaultTextAttributes = attributes
            }
            
        }
        return searchBar
    }()
    
    // MARK: - Properties
    
    private let viewModel = FlowerSearchViewModel()
    lazy var filteredItems: [FlowerSearchModel] = []
    let tempData: [String] = [
        "히아신스", "아네모네", "아마란서스", "아마릴리스", "아이리스", "장미", "튤립", "그냥 꽃"
    ]
    private var isFiltering: Bool = false
    private var searchedText: String = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        viewModel.fetchFlowersForSearch()
        
        searchBar.delegate = self
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.titleView = searchBar
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        let backbutton = UIBarButtonItem(image: UIImage.chevronLeft, style: .done, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = backbutton
        
        let backgroundImage = getImageWithCustomColor(color: UIColor.gray03, size: CGSize(width: 350, height: 40))
        searchBar.setSearchFieldBackgroundImage(backgroundImage, for: .normal)
        
        addViews()
        setupConstraints()
    }
    
    // MARK: - Actions
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
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
    
    func getImageWithCustomColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func bind(){
        viewModel.flowerSearchListDidChange = {
        
        }
    }
}

// MARK: - Extension; TableView
extension FlowerSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? (filteredItems.isEmpty ? 1 : filteredItems.count) : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FlowerSearchResultCell.identifier, for: indexPath) as! FlowerSearchResultCell
        
        // 검색 중일 때만
        if isFiltering {
            // 검색 결과 있을 때
            if !filteredItems.isEmpty {
                let filteredFlowerSearchModel = filteredItems[indexPath.row]
                
                let attributeString = NSMutableAttributedString(string: filteredFlowerSearchModel.flowerName)
                
                /* 검색된 텍스트와 일치하는 부분 다른 색으로 처리 */
                var textFirstIndex: Int = 0  // 검색중인 키워드가 가장 처음 나온 인덱스
                
                // 검색 중인 키워드가 가장 처음으로 일치하는 문자열의 범위 구하기
                if let textFirstRange = filteredFlowerSearchModel.flowerName.range(of: "\(searchedText)", options: .caseInsensitive) {
                    // 거리(인덱스) 구해서 저장
                    textFirstIndex = filteredFlowerSearchModel.flowerName.distance(from: filteredFlowerSearchModel.flowerName.startIndex, to: textFirstRange.lowerBound)
                    
                    attributeString.addAttribute(.foregroundColor, value: UIColor(red: 46/255, green: 225/255, blue: 176/255, alpha: 1), range: NSRange(location: textFirstIndex, length: searchedText.count))
                    cell.configure(id: filteredFlowerSearchModel.flowerId, attributedFlowerName: attributeString)
                }
            }
            // 검색 결과 없을 때의 셀
            else{
                guard let noResultCell = tableView.dequeueReusableCell(withIdentifier: NoSearchResultCell.identifier, for: indexPath) as? NoSearchResultCell else { return UITableViewCell()}
                return noResultCell
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering && !filteredItems.isEmpty{
            tableView.deselectRow(at: indexPath, animated: false)
            navigationController?.pushViewController(FlowerDetailViewController(flowerId: 1), animated: true)
        }
    }
}

// MARK: - Extension; Search
extension FlowerSearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isFiltering = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedText = searchBar.text ?? ""
        self.filteredItems = viewModel.getFilteredFlowers(searchedText: searchedText)
        self.searchTableView.reloadData()
    }
}
