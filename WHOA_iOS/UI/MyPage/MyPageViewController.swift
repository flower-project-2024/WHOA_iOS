//
//  MyPageViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/22/24.
//

import UIKit

class MyPageViewController: UIViewController {
    // MARK: - Properties
    let savedRequestList: [String] = ["꽃다발 요구서1", "꽃다발 요구서2", "꽃다발 요구서3"]
    
    // MARK: - Views
    private let viewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "저장된 요구서"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.textAlignment = .left
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SavedRequestCell.self, forCellReuseIdentifier: SavedRequestCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 160
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigation()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Helpers
    
    private func setupNavigation(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewTitleLabel)
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.barTintColor = .white  // TODO: white or not?
    }
    
    private func addViews(){
        view.addSubview(viewTitleLabel)
        view.addSubview(tableView)
    }
    
    private func setupConstraints(){
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Extension; TableView
extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedRequestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedRequestCell.identifier, for: indexPath) as? SavedRequestCell else { return UITableViewCell() }
        //cell.requestTitleLabel.text = savedRequestList[indexPath.item]
        cell.writtenDateLabel.text = "2024.01.12"
        
        cell.selectionStyle = .none
        
        cell.myPageVC = self
        cell.setTitle(title: savedRequestList[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160+16
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell selected")
        self.navigationController?.pushViewController(RequestDetailViewController(requestTitle: savedRequestList[indexPath.item]), animated: true)
        return
    }
    
}
