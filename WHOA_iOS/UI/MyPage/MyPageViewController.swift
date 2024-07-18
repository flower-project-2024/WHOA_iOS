//
//  MyPageViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/22/24.
//

import UIKit

final class MyPageViewController: UIViewController, CustomAlertViewControllerDelegate {
    
    // MARK: - Properties
    
    private let viewModel = BouquetListModel()
    private let cellVerticalSpacing: CGFloat = 8
    private var noRequest = true
    var customizingCoordinator: CustomizingCoordinator?
    
    // MARK: - Views
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "저장된 요구서"
        label.font = UIFont.Pretendard(size: 20, family: .SemiBold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SavedRequestCell.self, forCellReuseIdentifier: SavedRequestCell.identifier)
        tableView.register(NoRequestCell.self, forCellReuseIdentifier: NoRequestCell.identifier)
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = .zero
        tableView.sectionFooterHeight = cellVerticalSpacing
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchAllBouquets(fromCurrentVC: self)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        bind()
        setupNavigation()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Helpers
    
    private func setupNavigation(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func addViews(){
        view.addSubview(tableView)
    }
    
    private func setupConstraints(){
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(6)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
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
    
    // MARK: - CustomAlertViewControllerDelegate
    
    func deleteSuccessful(bouquetId: Int) {
        viewModel.removeBouquet(withId: bouquetId)
    }
}

// MARK: - Extension; TableView

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = viewModel.getBouquetModelCount()
        noRequest = count == 0 ? true : false
        return count == 0 ? 1 : count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cellVerticalSpacing
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if noRequest {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoRequestCell.identifier, for: indexPath) as? NoRequestCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedRequestCell.identifier, for: indexPath) as? SavedRequestCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            let model = viewModel.getBouquetModel(index: indexPath.section)
            cell.myPageVC = self
            cell.configure(model: model)
            cell.customizingCoordinator = customizingCoordinator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !noRequest {
            let bouquetModel = viewModel.getBouquetModel(index: indexPath.row)
            let vc = RequestDetailViewController(with: bouquetModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
    
}
