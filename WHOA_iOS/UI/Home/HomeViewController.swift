//
//  ViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/4/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var carouselView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumLineSpacing = 0
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        //collectionView.isPagingEnabled = true  // cellSize의 width가 collectionView의 width와 같지 않기 때문에
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var tooltipView = ToolTipView()
    
    // MARK: - Properties
    private var cheapFlowerView = CheapFlowerView()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "어떤 꽃을 찾으시나요?"
        searchBar.searchTextField.font = UIFont(name: "Pretendard-Regular", size: 14)
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
    
    private var cellSize: CGSize = .zero
    private var timer: Timer? = Timer()
    private let minimumLineSpacing: CGFloat = 0
    private var collectionViewCellCount: [String] = ["0", "1"]
    
    var tooltipIsClosed = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
//        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//        print(launchedBefore)
    
        addViews()
        setupNavigation()
        setupConstraints()
        
        let backgroundImage = getImageWithCustomColor(color: UIColor.gray03, size: CGSize(width: 350, height: 54))
        searchBar.setSearchFieldBackgroundImage(backgroundImage, for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupCollectionView()
        setupTableView()
        if(!tooltipIsClosed){
            setupToolTipView()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        resetTimer()
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Helper
    private func addViews(){
        view.addSubview(searchBar)
        view.addSubview(carouselView)
        view.addSubview(cheapFlowerView)
    }
    
    private func setupNavigation(){
        // 내비게이션 바에 로고 이미지
        let logoImageView = UIImageView(image: UIImage.whoaLogo)
        self.navigationItem.titleView = logoImageView
        
        // 네비게이션 바 줄 없애기
//        self.navigationController?.navigationBar.standardAppearance.shadowColor = .white  // 스크롤하지 않는 상태
//        self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .white  // 스크롤하고 있는 상태
    }
    
    private func setupConstraints(){
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupCollectionView(){
        // minimumLineSpacing 고려하여 width 값 조절
        cellSize = CGSize(width: carouselView.bounds.width - (minimumLineSpacing * 4), height: 225)
        carouselView.contentInset = UIEdgeInsets(top: 0,
                                                 left: minimumLineSpacing * 2,
                                                 bottom: 0,
                                                 right: minimumLineSpacing)
        carouselView.delegate = self
        carouselView.dataSource = self
        
        carouselView.decelerationRate = .fast
        
        carouselView.register(TodaysFlowerViewCell.self, forCellWithReuseIdentifier: TodaysFlowerViewCell.identifier)
        carouselView.register(CustomizeIntroCell.self, forCellWithReuseIdentifier: CustomizeIntroCell.identifier)
    }
    
    private func setupTableView(){
        cheapFlowerView.topThreeTableView.dataSource = self
        cheapFlowerView.topThreeTableView.delegate = self
    }
    
    private func setupToolTipView(){
        view.addSubview(tooltipView)
        
        tooltipView.parentVC = self
        
        tooltipView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(12 + 21 + 5)
        }
        
//        print("tooltipView.frame.height: \(tooltipView.frame.height)")
        tooltipView.layoutIfNeeded()
//        print("tooltipView.frame.height: \(tooltipView.frame.height)")
//        print("tooltipView.bounds.size: \(tooltipView.bounds.size)")
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
    
    private func getImageWithCustomColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func drawTip(
        tipStartX: CGFloat,
        tipStartY: CGFloat,
        tipWidth: CGFloat,
        tipHeight: CGFloat) {

        let path = CGMutablePath()

        let tipWidthCenter = tipWidth / 2.0
        let endXWidth = tipStartX + tipWidth

        path.move(to: CGPoint(x: tipStartX, y: tipStartY))
        path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter, y: tipStartY+tipHeight))
        path.addLine(to: CGPoint(x: endXWidth, y: tipStartY))
        path.addLine(to: CGPoint(x: tipStartX, y: tipStartY))

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.primary.cgColor

        self.view.layer.insertSublayer(shape, at: 0)
    }
    
    func removeToolTipView(){
        tooltipIsClosed = true
        tooltipView.removeFromSuperview()
//        tooltipView = 
    }
}

// MARK: - Extensions; TableView
extension HomeViewController : UITableViewDataSource {
    // 섹션 당 셀 개수: 3
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheapFlowerInfoCell.identifier, for: indexPath) as! CheapFlowerInfoCell
        cell.rankingLabel.text = "\(indexPath.row + 1)"
        return cell
    }
    
//    // TableView의 rowHeight속성에 AutometicDimension을 통해 테이블의 row가 유동적이라는 것을 선언
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
}

extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        timer?.invalidate()
        timer = nil
        let vc = FlowerDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Extensions; ScrollView
//extension UIScrollView {
//    func updateContentSize() {
//        let unionCalculatedTotalRect = recursiveUnionInDepthFor(view: self)
//        
//        // 계산된 크기로 컨텐츠 사이즈 설정
//        self.contentSize = CGSize(width: self.frame.width, height: unionCalculatedTotalRect.height+50)
//    }
//    
//    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
//        var totalRect: CGRect = .zero
//        
//        // 모든 자식 View의 컨트롤의 크기를 재귀적으로 호출하며 최종 영역의 크기를 설정
//        for subView in view.subviews {
//            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
//        }
//        
//        // 최종 계산 영역의 크기를 반환
//        return totalRect.union(view.frame)
//    }
//}

// MARK: - Extensions; CollectionView
extension HomeViewController: UICollectionViewDelegate {
    // Tells the delegate when the user finishes scrolling the content. -> 다음 셀이 중앙에 오도록 하기
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludingSpacing: CGFloat = cellSize.width + minimumLineSpacing

        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: Int
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }

        targetContentOffset.pointee = CGPoint(x: (CGFloat(index) * cellWidthIncludingSpacing) - (minimumLineSpacing * 2), y: 0)
        
        // 직접 스크롤하면 타이머 초기화
        resetTimer()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodaysFlowerViewCell.identifier, for: indexPath) as! TodaysFlowerViewCell
            cell.buttonCallbackMethod = { [self] in
                timer?.invalidate()
                timer = nil
                let vc = FlowerDetailViewController()
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomizeIntroCell.identifier, for: indexPath)
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

// MARK: - search bar
extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        timer?.invalidate()
        timer = nil
        let searchVC = FlowerSearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: true)
    }
}

// MARK: - Extension; UILabel (추후 Global 로 빼기)
// TODO: Global에 추가
extension UILabel {
    func setLineSpacing(spacing: CGFloat) {
        guard let text = text else { return }

        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
}
