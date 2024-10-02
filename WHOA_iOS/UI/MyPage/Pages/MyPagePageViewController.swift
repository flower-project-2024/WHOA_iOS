//
//  MyPagePageViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 8/31/24.
//

import UIKit
import SnapKit

final class MyPagePageViewController: UIViewController {
    
    // MARK: - Properties
    
    let type: BouquetStatusType
    let myPageVC: MyPageViewController
    
    private var noRequest = true
    private var bouquetList: [BouquetModel] = []
    
    // MARK: - Views
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        if type == .all {
            tableView.backgroundColor = .secondary01
        }
        else if type == .saved {
            tableView.backgroundColor = .secondary02
        }
        else {
            tableView.backgroundColor = .secondary03
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SavedRequestCell.self, forCellReuseIdentifier: SavedRequestCell.identifier)
        tableView.register(NoRequestCell.self, forCellReuseIdentifier: NoRequestCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .init(top: 0,
                                         left: 20.adjusted(),
                                         bottom: 0,
                                         right: 20.adjusted())
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    init(type: BouquetStatusType, parentVC: MyPageViewController) {
        self.type = type
        self.myPageVC = parentVC

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setupConstraints()
    }

    // MARK: - Functions
    
    private func addViews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setTableViewData(_ bouquetList: [BouquetModel]) {
        self.bouquetList = bouquetList
        self.tableView.reloadData()
    }
}

// MARK: - Extension: UITableView

extension MyPagePageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = bouquetList.count
        noRequest = count == 0 ? true : false
        return count == 0 ? 1 : count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if noRequest {
            tableView.separatorStyle = .none
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoRequestCell.identifier, for: indexPath) as? NoRequestCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        }
        else {
            tableView.separatorStyle = .singleLine
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedRequestCell.identifier, for: indexPath) as? SavedRequestCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            let model = bouquetList[indexPath.row]
            print(model)
            cell.myPageVC = myPageVC
            cell.configure(model: model)
            cell.customizingCoordinator = myPageVC.customizingCoordinator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("noRequest: \(noRequest)")
        if !noRequest {
            let model = bouquetList[indexPath.row]
            let vc = RequestDetailViewController(with: model)
            vc.hidesBottomBarWhenPushed = true
            myPageVC.navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
}
