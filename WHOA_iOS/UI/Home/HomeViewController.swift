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
    private var collectionViewCellCount: [String] = ["0", "1"]
    
    var tooltipIsClosed = false

    // MARK: - Views
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
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
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.decelerationRate = .fast
        
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
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
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
            make.bottom.equalTo(contentView.snp.bottom).inset(33)  // 탭바 중앙 아이템 이미지 inset 값 + 그림자로 안보이는 정도
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
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { timer in
            let cellWidthIncludingSpacing: CGFloat = self.cellSize.width + self.minimumLineSpacing
            let estimatedIndex = self.carouselView.contentOffset.x / cellWidthIncludingSpacing
            let index = Int(round(estimatedIndex))

            // 현재가 마지막 아이템이면 첫 인덱스로, 아니면 +1
            let next = (index + 1 == self.collectionViewCellCount.count) ? 0 : index + 1
            
            if self.collectionViewCellCount.count == 0 { return }

            // 다음 지정된 인덱스로 스크롤
            self.carouselView.scrollToItem(at: IndexPath(item: next, section: 0), at: .centeredHorizontally, animated: true)
        })
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
    // Tells the delegate when the user finishes scrolling the content. -> 다음 셀이 중앙에 오도록 하기
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
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
        resetTimer()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getTodaysFlowerCount() + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
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
