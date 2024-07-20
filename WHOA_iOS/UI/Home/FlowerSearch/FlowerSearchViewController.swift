//
//  FlowerSearchViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/17/24.
//

import UIKit

class FlowerSearchViewController: UIViewController {
    
    // MARK: - Views
    
    private let headerView = UIView()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.chevronLeft, for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "어떤 꽃을 찾으시나요?"
        searchBar.searchTextField.font = UIFont.Pretendard(family: .Regular)
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.layer.cornerRadius = 19
        searchBar.searchTextField.layer.borderColor = UIColor.gray04.cgColor
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.frame.size.width = searchBar.bounds.width
        searchBar.searchTextField.frame.size = searchBar.frame.size
        
        let searchIconResized = UIImage.searchIcon.resizeImage(size: CGSize(width: 24, height: 24))
        
        searchBar.setImage(searchIconResized, for: .search, state: .normal)
        searchBar.setImage(UIImage.searchCancel, for: .clear, state: .normal)
        
        searchBar.setPositionAdjustment(UIOffset(horizontal: 10, vertical: 0), for: .search)
        searchBar.setPositionAdjustment(UIOffset(horizontal: -10, vertical: 0), for: .clear)
        return searchBar
    }()
    
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FlowerSearchResultCell.self, forCellReuseIdentifier: FlowerSearchResultCell.identifier)
        tableView.register(NoSearchResultCell.self, forCellReuseIdentifier: NoSearchResultCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Properties
    
    private let viewModel = FlowerSearchViewModel()
    lazy var filteredItems: [FlowerSearchModel] = []
    private var isFiltering: Bool = false
    private var searchedText: String = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        bind()
        viewModel.fetchFlowersForSearch(fromCurrentVC: self)
        
        searchBar.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        
        addViews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        view.layoutSubviews()
        headerView.layoutSubviews()
        searchBar.setBackgroundColor(size: searchBar.frame.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Helpers
    
    private func addViews() {
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(searchBar)
        
        view.addSubview(searchTableView)
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(backButton.snp.height).multipliedBy(1)
            make.leading.equalToSuperview().inset(21)
            make.centerY.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(backButton.snp.trailing).offset(1)
            make.trailing.equalToSuperview().inset(29)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(5)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(40)
        }
        
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(19)
            make.leading.trailing.bottom.equalToSuperview()
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
    
    private func bind() {
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
            else {
                guard let noResultCell = tableView.dequeueReusableCell(withIdentifier: NoSearchResultCell.identifier, for: indexPath) as? NoSearchResultCell else { return UITableViewCell()}
                return noResultCell
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering && !filteredItems.isEmpty{
            tableView.deselectRow(at: indexPath, animated: false)
            let cell = tableView.cellForRow(at: indexPath) as? FlowerSearchResultCell
            navigationController?.pushViewController(FlowerDetailViewController(flowerId: cell!.flowerId), animated: true)
            self.navigationController?.navigationBar.isHidden = false
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
