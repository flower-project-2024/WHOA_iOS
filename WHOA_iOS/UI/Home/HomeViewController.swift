//
//  ViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/4/24.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel = HomeViewModel()
    private var cellSize: CGSize = .zero
    private var timer: Timer? = Timer()
    private let minimumLineSpacing: CGFloat = 0
    //private var collectionViewCellCount: [String] = ["0", "1", "]
    private var bannerItems: [Any] = []
    private var currentPage: Int = 1
    
    var tooltipIsClosed = false

    // MARK: - Views
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.isScrollEnabled = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var carouselView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumLineSpacing = 0
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.decelerationRate = .fast
        collectionView.isScrollEnabled = true
        
        collectionView.register(TodaysFlowerViewCell.self, forCellWithReuseIdentifier: TodaysFlowerViewCell.identifier)
        collectionView.register(CustomizeIntroCell.self, forCellWithReuseIdentifier: CustomizeIntroCell.identifier)
        return collectionView
    }()
    
    private var tooltipView = ToolTipView()

    private var cheapFlowerView = CheapFlowerView()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "어떤 꽃을 찾으시나요?"
        searchBar.searchTextField.font = .Pretendard()
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.layer.cornerRadius = 25
        searchBar.searchTextField.layer.borderColor = UIColor.gray04.cgColor
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.frame.size.width = searchBar.bounds.width
        searchBar.searchTextField.frame.size = searchBar.frame.size
        searchBar.setImage(UIImage.searchIcon, for: .search, state: .normal)
        return searchBar
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        bind()
        
        viewModel.fetchTodaysFlowerModel(getTodaysDate(), fromCurrentVC: self)
        viewModel.fetchCheapFlowerRanking(fromCurrentVC: self)
    
        addViews()
        setupNavigation()
        setupConstraints()
        
        let willShowTooltip = UserDefaults.standard.bool(forKey: "willShowTooltip")
        if(!willShowTooltip) {
            UserDefaults.standard.setValue(true, forKey: "willShowTooltip")
            setupToolTipView()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentView.layoutSubviews()
        searchBar.setBackgroundColor(size: searchBar.frame.size)
        
        setupCollectionView()
        setupTableView()
        
        for cell in cheapFlowerView.topThreeTableView.visibleCells {
            if let cheapFlowerInfoCell = cell as? CheapFlowerInfoCell {
                let stackViewFrame = cheapFlowerInfoCell.flowerInfoStackView
                cheapFlowerInfoCell.updateFlowerLanguageStackView()
            }
        }
        // 맨 처음 사진을 띄우기 위해 contentoffset.x을 한 번(기기 화면 너비만큼 = 셀 크기) 이동
        carouselView.setContentOffset(.init(x: cellSize.width, y: carouselView.contentOffset.y), animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("=== viewDidAppear ===")
        print("carouselView items: \(carouselView.visibleCells)")
        // 배너 무한 스크롤 - 현재 2, 1, 2, 1이라 2의 화면을 보여지고 있으므로 첫번째 1로 스크롤
//        carouselView.scrollToItem(at: [0, 1], at: .left, animated: false)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Functions
    
    private func addViews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(searchBar)
        contentView.addSubview(carouselView)
        contentView.addSubview(cheapFlowerView)
    }
    
    private func setupNavigation() {
        let logoImageView = UIImageView(image: UIImage.whoaLogo)
        self.navigationItem.titleView = logoImageView
        
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        
        self.navigationController?.navigationBar.tintColor = .primary
        self.navigationController?.navigationBar.topItem?.title = ""
        
        // 네비게이션 바 줄 없애기
        self.navigationController?.navigationBar.standardAppearance.shadowColor = .white  // 스크롤하지 않는 상태
        self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .white  // 스크롤하고 있는 상태
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.contentLayoutGuide.snp.leading)
            make.trailing.equalTo(scrollView.contentLayoutGuide.snp.trailing)
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
            make.width.equalTo(scrollView.frameLayoutGuide.snp.width)
        } 
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(17)  // 내비게이션 바의 높이 고려한 간격
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        carouselView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(225)
        }
        
        cheapFlowerView.snp.makeConstraints { make in
            make.top.equalTo(carouselView.snp.bottom).offset(29)
            make.horizontalEdges.equalTo(searchBar.snp.horizontalEdges)
            make.bottom.equalTo(contentView.snp.bottom).inset(15)
        }
    }
    
    private func setupCollectionView() {
        // minimumLineSpacing 고려하여 width 값 조절
        carouselView.layoutIfNeeded()
        cellSize = CGSize(width: carouselView.frame.width - (minimumLineSpacing * 4), height: 225)
        carouselView.contentInset = UIEdgeInsets(top: 0,
                                                 left: minimumLineSpacing * 2,
                                                 bottom: 0,
                                                 right: minimumLineSpacing)
    }
    
    private func setupTableView() {
        cheapFlowerView.topThreeTableView.dataSource = self
        cheapFlowerView.topThreeTableView.delegate = self
    }
    
    private func setupToolTipView() {
        view.addSubview(tooltipView)
        
        tooltipView.parentVC = self
        
        tooltipView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12 + 21 + 12) // tip 높이 + 탭바의 커스터마이징 이미지의 inset 값 + 그림자로 안보이는 정도
        }
        
        tooltipView.layoutIfNeeded()
        let tipStartX = tooltipView.bounds.width / 2 - 13/2
        let tipStartY = tooltipView.bounds.height
        tooltipView.drawTip(tipStartX: tipStartX,
                            tipStartY: tipStartY,
                            tipWidth: 13,
                            tipHeight: 12)
    }
    
    private func resetTimer() {
        print("== 타이머 세팅 ==")
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] timer in
            print("3초 타이머")
            
            let visibleItem = self?.carouselView.indexPathsForVisibleItems[0].item  // 현재 화면에 보이는 아이템의 indexPath
            let nextItem = (visibleItem ?? 0) + 1
            
            let actualCount = (self?.bannerItems.count)! - 2  // 배너 아이템의 실제 개수 (앞뒤 중복 빼고)
            
            print("현재 아이템:\(visibleItem), 다음 아이템: \(nextItem)")

            // 다음 indexPath의 item으로 스크롤
            self?.carouselView.scrollToItem(at: [0, nextItem], at: .centeredHorizontally, animated: true)

//            // 만약 다음번이 마지막이면 contentOffset을 맨 처음으로 설정해줘야 함
//            // DispatchQueue.main.asyncAfter없이 한다면 마지막에서 부자연스럽게(갑자기) 넘어가므로,
//            // 우선 다음번으로 scroll을 시키고, scroll 애니메이션이 다 끝났을 때 쯔음 contentOffset을 바꾸어줌
//            if visibleItem == actualCount {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self?.carouselView.scrollToItem(at: [0, 1], at: .centeredHorizontally, animated: false)
//                }
//            }
            
            // 마지막 커스터마이징 셀에 있는 경우 ->
            if nextItem == 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.carouselView.scrollToItem(at: [0, 0], at: .centeredHorizontally, animated: false)
                }
            }
            // 마지막 오늘의 꽃 셀에 있는 경우
            else if nextItem == 3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.carouselView.scrollToItem(at: [0, 1], at: .centeredHorizontally, animated: false)
                }
            }
        }
    }
    
    private func moveCarouselView() {
        print("=== move carousel view ===")
        print("currentPage: \(currentPage)")
        
        currentPage += 1
        carouselView.scrollToItem(at: [0, currentPage], at: .right, animated: true)
        
        // 마지막 셀인 경우 다시 돌아가야 하므로 애니메이션이 실행되는 시간인 0.3초 딜레이 후에 1번 셀로 애니메이션 없이 이동 -> 눈속임
        if self.currentPage == bannerItems.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.carouselView.scrollToItem(at: [0, 1], at: .left, animated: false)
                self?.currentPage = 0
            }
        }
    }
    
    private func bind() {
        viewModel.cheapFlowerRankingsDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.cheapFlowerView.topThreeTableView.reloadData()
                self?.cheapFlowerView.setBaseDateLabel(viewModel: self!.viewModel)
            }
        }
        
        viewModel.todaysFlowerDidChange = { [weak self] in
            DispatchQueue.main.async {
                // as -is: 1 2
                // to -be: 2 1 2 1
                self?.setBannerItems()
                self?.carouselView.reloadData()
                self?.resetTimer()
            }
        }
    }
    
    private func getTodaysDate() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        let splitArray = currentDate.split(separator: "-")
        var returnArray = ["", ""]
        
        // 월, 날짜가 한 자리 수인 경우 앞에 0을 제거해야 함
        for i in 0...1 {
            if splitArray[i].prefix(1) == "0" {
                returnArray[i] = String(splitArray[i].suffix(1))
            }
            else {
                returnArray[i] = String(splitArray[i])
            }
        }
        return returnArray
    }
    
    private func setBannerItems() {
        bannerItems.append(CustomizeIntroCell())
        bannerItems.append(viewModel.getTodaysFlower())
        bannerItems.append(CustomizeIntroCell())
        bannerItems.append(viewModel.getTodaysFlower())
    }

    func removeToolTipView() {
        tooltipIsClosed = true
        tooltipView.removeFromSuperview()
    }
}

// MARK: - Extension: UITableView

extension HomeViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCheapFlowerModelCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheapFlowerInfoCell.identifier, for: indexPath) as! CheapFlowerInfoCell
        cell.rankingLabel.text = "\(indexPath.row + 1)"
        
        let model = viewModel.getCheapFlowerModel(index: indexPath.row)
        cell.configure(model: model)
        return cell
    }
}

extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        timer?.invalidate()
        timer = nil
        let cell = tableView.cellForRow(at: indexPath) as! CheapFlowerInfoCell
        if let id = cell.flowerId {
            let vc = FlowerDetailViewController(flowerId: id)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }        
    }
}

// MARK: - Extension: UICollectionView

extension HomeViewController: UICollectionViewDelegate {
    
    // 직접 스크롤했을 경우 -> 다음 셀이 중앙에 오도록 하는 페이징 효과 위함
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("== scrollViewWillEndDragging ==")
        let cellWidthIncludingSpacing: CGFloat = cellSize.width + minimumLineSpacing

        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: Int
        
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } 
        else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } 
        else {
            index = Int(round(estimatedIndex))
        }

        targetContentOffset.pointee = CGPoint(x: (CGFloat(index) * cellWidthIncludingSpacing) - (minimumLineSpacing * 2), y: 0)
        
        // 직접 스크롤하면 타이머 초기화
        //resetTimer()
        // 어차피 이후 scrollViewDidEndDecelerating이 resetTimer 실행함
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("== scrollViewDidEndDecelerating ==")
        // 2, 1, 2, 1 데이터가 있을때,
        // 첫번째 2가 보일땐 3번째 2로 이동 (왼쪽에서 오른쪽으로 스크롤 헀을때 1이 나와야하므로)
        // 마지막 1이 보일땐 첫번째 1로 이동 (오른쪽으로 계속 스크롤 되는것처럼 보이기)
//        let count = bannerItems.count
//            
//        if scrollView.contentOffset.x == 0 {
//            scrollView.setContentOffset(.init(x: cellSize.width * Double(count - 2), y: scrollView.contentOffset.y), animated: false)
//        }
//        if scrollView.contentOffset.x == Double(count - 1) * cellSize.width {
//            scrollView.setContentOffset(.init(x: cellSize.width, y: scrollView.contentOffset.y), animated: false)
//        }
        
        // resetTimer()
        
        // 새로 적용
        // 2 1 2 1
        resetTimer()
        
        if scrollView.contentOffset.x == 0 { // 첫번째(2)가 보이면 2번째 index의 2로 이동시키기
            scrollView.setContentOffset(.init(x: cellSize.width * 2, y: scrollView.contentOffset.y), animated: false)
        }
        else if scrollView.contentOffset.x == cellSize.width * 3 { // 마지막 1이 보이면 1번째 index의 1로 이동
            scrollView.setContentOffset(.init(x: cellSize.width, y: scrollView.contentOffset.y), animated: false)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return viewModel.getTodaysFlowerCount() + 1
        return bannerItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 || indexPath.item == 3 {
            print("=== 오늘의 꽃을 보여줍니다 ===")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodaysFlowerViewCell.identifier, for: indexPath) as! TodaysFlowerViewCell

            cell.configure(viewModel.getTodaysFlower())
            
            cell.buttonCallbackMethod = { [weak self] in
                self?.timer?.invalidate()
                self?.timer = nil
                let vc = FlowerDetailViewController(flowerId: cell.flowerId ?? 1)
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        else {
            print("=== 커스터마이징을 보여줍니다 ===")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomizeIntroCell.identifier, for: indexPath) as! CustomizeIntroCell
            cell.goToCustomzingFromCustomizingCell = { [weak self] in
                self?.tabBarController?.selectedIndex = 1
            }
            return cell
        }
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
}

// MARK: - Extension: UISearchBar

extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        timer?.invalidate()
        timer = nil
        let searchVC = FlowerSearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: true)
    }
}
