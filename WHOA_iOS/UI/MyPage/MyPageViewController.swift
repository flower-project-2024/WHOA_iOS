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
    private let underlineViewWidth: CGFloat = (UIScreen.main.bounds.width - 20.adjusted(basedOnWidth: 390) * 2) / 3
    private var noRequest = true
    private var pageViewControllerList: [UIViewController] = []
    var customizingCoordinator: CustomizingCoordinator?
    
    private var currentPage: Int = 0 {
        didSet {
            print(oldValue, self.currentPage)
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
    
    private lazy var vc3 = MyPagePageViewController(type: .made, parentVC: self)
    
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
        
        print("VC1: \(vc1)")
        print("VC2: \(vc2)")
        
        // segment control에 그림자 추가
        segmentContainerView.layer.applyShadow(alpha: 0.04, height: 6, blur: 12 / UIScreen.main.scale)
        segmentControl.addTarget(self, action: #selector(changeSelectedSegmentLinePosition), for: .valueChanged)
        segmentControl.addTarget(self, action: #selector(segmentIndexDidChange(_:)), for: .valueChanged)
    }
    
    // MARK: - Actions
    
    @objc private func changeSelectedSegmentLinePosition() {
        print("changeSelectedSegmentLinePosition")
        lazy var leadingValue: CGFloat = CGFloat(segmentControl.selectedSegmentIndex) * underlineViewWidth
        UIView.animate(withDuration: 0.3, animations: {
            self.segmentUnderLineView.snp.updateConstraints { $0.leading.equalTo(self.segmentControl.snp.leading).offset(leadingValue)
            }
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func segmentIndexDidChange(_ segment: UISegmentedControl) {
        print("선택된 세그먼트: \(segment.selectedSegmentIndex)")
        currentPage = segment.selectedSegmentIndex
        
        lazy var leadingValue: CGFloat = CGFloat(segmentControl.selectedSegmentIndex) * underlineViewWidth
        print("leadingValue: \(leadingValue)")
        UIView.animate(withDuration: 0.3, animations: {
            self.segmentUnderLineView.snp.updateConstraints { $0.leading.equalTo(self.segmentControl.snp.leading).offset(leadingValue)
            }
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - Functions
    
    private func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func addViews() {
        view.addSubview(segmentContainerView)
        segmentContainerView.addSubview(segmentControl)

        view.addSubview(segmentUnderLineView)
        view.addSubview(pageViewController.view)
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
                self?.vc3.setTableViewData(self?.viewModel.getBouquetsByType(.made) ?? [])
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
                            transitionCompleted completed: Bool) {
        print("pageVC의 뷰컨들: \(pageViewController.viewControllers)")
        guard let viewController = pageViewController.viewControllers?[0],
                let index = self.pageViewControllerList.firstIndex(of: viewController)
        else { return }
        
        self.currentPage = index
        self.segmentControl.selectedSegmentIndex = index
        changeSelectedSegmentLinePosition()
    }
}
