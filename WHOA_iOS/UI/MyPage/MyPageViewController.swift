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
    private let cellVerticalSpacing: CGFloat = 8.adjustedH()
    private let underlineViewWidth: CGFloat = (UIScreen.main.bounds.width - 20.adjusted() * 2) / 3
    private var pageViewControllerList: [UIViewController] = []
    var customizingCoordinator: CustomizingCoordinator?
    
    private var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = (oldValue <= self.currentPage) ? .forward : .reverse
            self.pageViewController.setViewControllers(
                [pageViewControllerList[self.currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
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
    
    private lazy var vc1 = MyPagePageViewController(type: .all, parentVC: self)
    private lazy var vc2 = MyPagePageViewController(type: .saved, parentVC: self)
    private lazy var vc3 = MyPagePageViewController(type: .producted, parentVC: self)
    
    private lazy var pageViewController: UIPageViewController = {
        pageViewControllerList = [vc1, vc2, vc3]
        
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.setViewControllers([self.pageViewControllerList[0]], direction: .forward, animated: true)
        vc.delegate = self
        vc.dataSource = self
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        return vc
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
        
        segmentControl.addTarget(self, action: #selector(segmentIndexDidChange(_:)), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureShadow()
    }
    
    // MARK: - Actions
    
    @objc private func segmentIndexDidChange(_ segment: UISegmentedControl) {
        currentPage = segment.selectedSegmentIndex
        changeSelectedSegmentLinePosition()
    }
    
    // MARK: - Functions
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func addViews() {
        view.addSubview(pageViewController.view)

        view.addSubview(segmentContainerView)
        segmentContainerView.addSubview(segmentControl)
        segmentContainerView.addSubview(segmentUnderLineView)
    }
    
    private func setupConstraints() {
        segmentContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20.adjustedH())
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(47.adjustedH())
        }
        
        segmentControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20.adjusted())
            make.trailing.equalToSuperview().inset(20.adjusted())
            make.top.equalToSuperview()
        }
        
        segmentUnderLineView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom)
            make.height.equalTo(4.adjustedH())
            make.width.equalTo(underlineViewWidth)
            make.leading.equalTo(segmentControl.snp.leading)
            make.bottom.equalToSuperview()
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(segmentContainerView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        viewModel.bouquetModelListDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.vc1.setTableViewData(self?.viewModel.getBouquetsByType(.all) ?? [])
                self?.vc2.setTableViewData(self?.viewModel.getBouquetsByType(.saved) ?? [])
                self?.vc3.setTableViewData(self?.viewModel.getBouquetsByType(.producted) ?? [])
            }
        }
    }
    
    /// segment 변경이 있을 경우 밑의 under line의 위치 변경해주는 메소드
    private func changeSelectedSegmentLinePosition() {
        lazy var leadingValue: CGFloat = CGFloat(segmentControl.selectedSegmentIndex) * underlineViewWidth
        UIView.animate(withDuration: 0.3, animations: {
            self.segmentUnderLineView.snp.updateConstraints { $0.leading.equalTo(self.segmentControl.snp.leading).offset(leadingValue)
            }
            self.view.layoutIfNeeded()
        })
    }
    
    /// segment control 아래에 그림자를 세팅하는 메소드
    private func configureShadow() {
        let bounds = segmentContainerView.bounds
        
        segmentContainerView.layer.applyShadowByUIBezierPath(color: .black,
                                                             alpha: 0.08,
                                                             offsetWidth: 0,
                                                             offsetHeight: 0,
                                                             shadowWidth: bounds.width,
                                                             shadowHeight: 3,
                                                             blur: 12.adjustedH() / UIScreen.main.scale,
                                                             x: bounds.origin.x,
                                                             y: bounds.origin.y + bounds.height - 1)
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
        return count == 0 ? 1 : count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cellVerticalSpacing
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isBouquetModelListEmpty() {
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
        if !viewModel.isBouquetModelListEmpty() {
            let bouquetModel = viewModel.getBouquetModel(index: indexPath.row)
            let vc = RequestDetailViewController(with: bouquetModel)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
    }
}

// MARK: - Extension: UIPageViewController

extension MyPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // 이전 뷰를 설정
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.pageViewControllerList.firstIndex(of: viewController), index - 1 >= 0
        else { return nil }
        return self.pageViewControllerList[index - 1]
    }
    
    // 다음 뷰를 설정
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.pageViewControllerList.firstIndex(of: viewController), index + 1 < self.pageViewControllerList.count
        else { return nil }
        
        return self.pageViewControllerList[index + 1]
    }
    
    // 몇 번째 페이지가 로드되었는지 (-> segment control도 이동)
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool
    ) {
        guard let viewController = pageViewController.viewControllers?[0],
                let index = self.pageViewControllerList.firstIndex(of: viewController)
        else { return }
        
        self.currentPage = index
        self.segmentControl.selectedSegmentIndex = index
        changeSelectedSegmentLinePosition()
    }
}
