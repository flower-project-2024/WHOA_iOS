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
    private let underlineViewWidth: CGFloat = (UIScreen.main.bounds.width - 20.adjusted(basedOnWidth: 390) * 2 - 15.adjusted(basedOnWidth: 390) * 2) / 3
    private var noRequest = true
    var customizingCoordinator: CustomizingCoordinator?
    
    // MARK: - Views
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃다발 요구서"
        label.font = UIFont.Pretendard(size: 20, family: .SemiBold)
        label.textAlignment = .left
        return label
    }()
    
    private let segmentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = false
//        view.layer.applyShadow(y: 47.,blur: 12)
//        view.layer.shadowOffset = CGSize(width: 0, height: 4)
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowRadius = 8  // 반경?
//        view.layer.shadowOpacity = 0.3  // alpha값입니다.
        return view
    }()
    
    private let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "전체", at: 0, animated: true)
        segment.insertSegment(withTitle: "저장된 요구서", at: 1, animated: true)
        segment.insertSegment(withTitle: "제작 완료", at: 2, animated: true)
        segment.selectedSegmentIndex = 0
        
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray06,
            NSAttributedString.Key.font: UIFont.Pretendard(size: 16)],
                                       for: .normal)
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.Pretendard(size: 16, family: .SemiBold)],
                                       for: .selected)
        
        segment.selectedSegmentTintColor = .clear
        segment.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segment.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        segment.setBackgroundImage(UIImage(), for: .highlighted, barMetrics: .default)
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        return segment
    }()
    
    private let segmentUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
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
        
        // segment control에 그림자 추가
        segmentContainerView.layer.applyShadow(alpha: 0.04, height: 6, blur: 12 / UIScreen.main.scale)
    }
    
    // MARK: - Functions
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func addViews() {
        view.addSubview(segmentContainerView)
        segmentContainerView.addSubview(segmentControl)
//        view.addSubview(segmentControl)
        view.addSubview(segmentUnderLineView)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        segmentContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(47)
        }
        
        segmentControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20.adjusted(basedOnWidth: 390))
            make.trailing.equalToSuperview().inset(20.adjusted(basedOnWidth: 390))
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        segmentUnderLineView.snp.makeConstraints { make in
            make.bottom.equalTo(segmentControl.snp.bottom)
            make.height.equalTo(4)
            make.width.equalTo(underlineViewWidth)
            make.leading.equalTo(segmentControl.snp.leading)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(36)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
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

// MARK: - Extension: TableView

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
