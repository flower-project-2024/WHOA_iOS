//
//  MyPageViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/22/24.
//

import UIKit

class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = BouquetListModel()
    
    // MARK: - Views
    private let viewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "저장된 요구서"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var tableView: UITableView = {
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
        
        bind()
        viewModel.fetchAllBouquets(fromCurrentVC: self)
        
        setupNavigation()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Helpers
    
    private func setupNavigation(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: viewTitleLabel)
        self.navigationController?.navigationBar.shadowImage = UIImage()
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
    
    private func bind(){
        viewModel.bouquetModelListDidChage = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - Extension; TableView
extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getBouquetModelCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedRequestCell.identifier, for: indexPath) as? SavedRequestCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        let model = viewModel.getBouquetModel(index: indexPath.row)
        cell.myPageVC = self
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160+16
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(indexPath.item)")
//        self.navigationController?.pushViewController(RequestDetailViewController(requestTitle: savedRequestList[indexPath.item]), animated: true)
//        return
    }
    
}
