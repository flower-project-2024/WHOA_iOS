//
//  FlowerDetailViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/9/24.
//

import UIKit

class FlowerDetailViewController: UIViewController {
    // MARK: - Views
    private let outerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.alwaysBounceHorizontal = false
        return scrollView
    }()
    
    private lazy var imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var imagePageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.5)
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    private let titleView: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        label.textColor = .primary
        return label
    }()

    private let flowerNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .bottom
        return stackView
    }()
    
    private let flowerKoreanNameLabel: UILabel = {
        let label = UILabel()
        label.text = "튤립"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        label.textColor = UIColor.primary
        return label
    }()
    
    private let flowerEnglishNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Tulip"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor.primary
        return label
    }()
    
    private let borderLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        return view
    }()
    
    private let flowerDescTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "시대불문 모두에게 사랑받는 꽃, 튤립"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = UIColor.secondary04
        return label
    }()
    
    private lazy var flowerDescContentLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃 이름을 잘 모르는 사람이라도 누구나 아는 꽃이 튤립일지 모른다. 매년 신품종이 잇따라 등장하며 추운 겨울부터 꽃집 앞을 장식한다. 홑꽃형, 겹꽃형, 백합형, 페럿형, 프린지형 등 화형이 다양하며 색상도 풍부하다. 모든 어레인지먼트에 적합한 화재로, 빛이나 온도에 따라 꽃이 벌어졌다가 오므라들기를 반복하며 색다른 이미지를 연출한다. 튤립만으로 일종꽂이해도 좋고, 다양한 종류를 혼합해 유리 화기 등에 꽂아도 근사하다."
        label.numberOfLines = 2  // 초기 줄 수는 2 (접은 상태)
        label.setLineSpacing(spacing: 5)
        label.textAlignment = .justified
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.textColor = UIColor(red: 66/255, green: 66/255, blue: 68/255, alpha: 1)
        return label
    }()
    
    private let flowerDescToggleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        button.setTitleColor(UIColor.gray06, for: .normal)
        button.setTitleColor(UIColor.gray06, for: .selected)

        button.setTitle("설명 보기", for: .normal)
        button.setImage(UIImage.chevronDown, for: .normal)
        button.setTitle("접기", for: .selected)
        button.setImage(UIImage.chevronUp, for: .selected)
        button.semanticContentAttribute = .forceRightToLeft

        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(descButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let thickBorderLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray02
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "정보"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        label.textColor = UIColor.primary
        return label
    }()
    
    private let birthFlowerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()
    
    private let birthFlowerLabel: UILabel = {
        let label = UILabel()
        label.text = "탄생화"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textColor = UIColor.primary
        return label
    }()
    
    private let birthFlowerDateLabel: HashTagCustomLabel = {
        let label = HashTagCustomLabel(padding: .init(top: 6, left: 12, bottom: 6, right: 12))
        label.text = "8월 15일"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.backgroundColor = UIColor.gray03
        return label
    }()
    
    private let borderLine1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        return view
    }()
    
    private let flowerLanguageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()
    
    private let flowerLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃말"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textColor = UIColor.primary
        return label
    }()
    
    private let flowerLanguageContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        return stackView
    }()
    
    private let flowerLanguageContentLabel1: HashTagCustomLabel = {
        let label = HashTagCustomLabel(padding: .init(top: 6, left: 12, bottom: 6, right: 12))
        label.text = "믿는 사랑"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.backgroundColor = UIColor.gray03
        return label
    }()
    
    private let flowerLanguageContentLabel2: HashTagCustomLabel = {
        let label = HashTagCustomLabel(padding: .init(top: 6, left: 12, bottom: 6, right: 12))
        label.text = "추억"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.backgroundColor = UIColor.gray03
        return label
    }()
    
    private let borderLine2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        return view
    }()
    
    private let flowerColorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        return stackView
    }()
    
    private let flowerColorLabel: UILabel = {
        let label = UILabel()
        label.text = "색상"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.textColor = UIColor.primary
        return label
    }()
    
    private let flowerColorChipHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 11
        stackView.alignment = .leading
        return stackView
    }()
    
    private let managementView =  ManagementView()
    
    private let bottomFixedView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowOpacity = 0.08
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
    
    private let decorateButton = DecorateButton()
    
    // MARK: - Properties
    var colorButtonList: [ColorChipButton] = []
    var imageList: [String] = []
    var tempName = "튤립"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageList = ["1", "2", "3"]
        
        view.backgroundColor = .white
        
        NetworkManager.shared.fetchFlowerDetail(flowerId: 1, completion: { result in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let error):
                print(error)
            }
        })
        imageScrollView.delegate = self
        outerScrollView.delegate = self
        
        decorateButton.addTarget(self, action: #selector(decorateBtnTapped), for: .touchUpInside)
        
        generateColorChipButtons()
        
        setupNavigation()

        addSubViews()
        setupConstraints()
        setPageControlCount(imageList.count)
        setScrollViewContent(images: imageList)  // 스크롤뷰에 이미지 세팅
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupCollectionView()
    }
    
    // MARK: - Functions

    private func setupNavigation(){
        self.navigationController?.navigationBar.tintColor = UIColor(named: "Primary")
        titleView.text = tempName
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.topItem?.title = ""
        
        let backbutton = UIBarButtonItem(image: UIImage(named: "ChevronLeft"), style: .done, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = backbutton

        // left bar button을 추가하면 기존에 되던 스와이프 pop 기능이 해제됨
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupCollectionView(){
        managementView.collectionView.delegate = self
        managementView.collectionView.dataSource = self
        
        managementView.collectionView.register(ManagementCell.self, forCellWithReuseIdentifier: ManagementCell.identifier)
//        ManagementView.cellSize = CGSize(width: managementView.collectionView.bounds.width - (minimumLineSpacing * 4), height: 258)
        
        managementView.collectionView.contentInset = UIEdgeInsets(top: 0,
                                                                  left: ManagementView.minimumLineSpacing * 2,
                                                                  bottom: 0,
                                                                  right: ManagementView.minimumLineSpacing)
    }
    
    private func addSubViews(){
        // add views
        view.addSubview(outerScrollView)
        view.addSubview(bottomFixedView)
        
        outerScrollView.addSubview(imageScrollView)
        outerScrollView.addSubview(imagePageControl)
        outerScrollView.addSubview(flowerNameStackView)
        outerScrollView.addSubview(borderLine)
        outerScrollView.addSubview(flowerDescTitleLabel)
        outerScrollView.addSubview(flowerDescContentLabel)
        outerScrollView.addSubview(flowerDescToggleButton)
        outerScrollView.addSubview(thickBorderLine)
        outerScrollView.addSubview(infoLabel)
        outerScrollView.addSubview(birthFlowerStackView)
        outerScrollView.addSubview(borderLine1)
        outerScrollView.addSubview(flowerLanguageStackView)
        outerScrollView.addSubview(borderLine2)
        outerScrollView.addSubview(flowerColorStackView)
        outerScrollView.addSubview(managementView)

        // add colorChipButtons to flowerColorChipHStackView
        colorButtonList.forEach({ button in
            button.snp.makeConstraints { make in
                make.width.equalTo(27.93)
                make.height.equalTo(27.93)
            }
            flowerColorChipHStackView.addArrangedSubview(button)
        })
        
        [flowerKoreanNameLabel, flowerEnglishNameLabel].forEach {
            flowerNameStackView.addArrangedSubview($0)
        }
        
        [birthFlowerLabel, birthFlowerDateLabel].forEach {
            birthFlowerStackView.addArrangedSubview($0)
        }
        
        [flowerLanguageLabel, flowerLanguageContentStackView].forEach {
            flowerLanguageStackView.addArrangedSubview($0)
        }
        
        [flowerLanguageContentLabel1, flowerLanguageContentLabel2].forEach {
            flowerLanguageContentStackView.addArrangedSubview($0)
        }
        
        [flowerColorLabel, flowerColorChipHStackView].forEach{
            flowerColorStackView.addArrangedSubview($0)
        }
        
        bottomFixedView.addSubview(decorateButton)
    }
    
    private func setupConstraints(){
        outerScrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(bottomFixedView.snp.top)
        }
        
        imageScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(307)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        imagePageControl.snp.makeConstraints { make in
            make.bottom.equalTo(imageScrollView.snp.bottom).inset(21)
            make.centerX.equalToSuperview()
        }
        
        flowerNameStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.top.equalTo(imageScrollView.snp.bottom).offset(28)
        }
        
        borderLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(flowerNameStackView.snp.bottom).offset(19)
        }
        
        flowerDescTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(28)
            make.top.equalTo(borderLine.snp.bottom).offset(19)
        }
        
        flowerDescContentLabel.snp.makeConstraints { make in
            make.leading.equalTo(flowerDescTitleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(28)
            make.top.equalTo(flowerDescTitleLabel.snp.bottom).offset(15)
        }
        
        flowerDescToggleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(28)
            make.top.equalTo(flowerDescContentLabel.snp.bottom).offset(13)
        }
        
        thickBorderLine.snp.makeConstraints { make in
            make.height.equalTo(11)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(flowerDescToggleButton.snp.bottom).offset(28)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(thickBorderLine).offset(40)
            make.leading.equalToSuperview().inset(26)
        }
        
        birthFlowerStackView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(27)
            make.leading.equalToSuperview().inset(28)
        }
        
        borderLine1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
            make.top.equalTo(birthFlowerStackView.snp.bottom).offset(22)
        }
        
        flowerLanguageStackView.snp.makeConstraints { make in
            make.leading.equalTo(birthFlowerStackView.snp.leading)
            make.top.equalTo(borderLine1.snp.bottom).offset(22)
        }
        
        borderLine2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
            make.top.equalTo(flowerLanguageStackView.snp.bottom).offset(22)
        }
        
        flowerColorStackView.snp.makeConstraints { make in
            make.top.equalTo(borderLine2.snp.bottom).offset(22)
            make.leading.equalTo(flowerLanguageStackView.snp.leading)
            make.trailing.equalToSuperview().inset(15)
        }
        
        managementView.snp.makeConstraints { make in
            make.top.equalTo(flowerColorStackView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        decorateButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
        }
        
        bottomFixedView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func generateColorChipButtons(){
        for _ in 0...8 {
            colorButtonList.append(ColorChipButton(colorCode: "#EFEFEF"))
        }
    }
    
    private func setPageControlCount(_ pages: Int) {
        imagePageControl.numberOfPages = pages
    }
    
    private func setScrollViewContent(images: [String]) { // scrolliVew에 imageView 추가하는 함수
        view.setNeedsLayout()  // 정확한 크기를 얻기 위해
        view.layoutIfNeeded()
        
        for index in 0..<images.count {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "FlowerImage.png")
            imageView.contentMode = .scaleAspectFit
            
            let xPosition = imageScrollView.frame.width * CGFloat(index)
            
            imageView.frame = CGRect(x: xPosition,
                                     y: 0,
                                     width: imageScrollView.bounds.width,
                                     height: imageScrollView.bounds.width)
            
            imageScrollView.addSubview(imageView)
            
            imageScrollView.contentSize.width = imageView.frame.width * CGFloat(index+1)
        }
    }
    // MARK: - Actions
    @objc func decorateBtnTapped(){
        let colorSheetVC = ColorSheetViewController()
        
        colorSheetVC.modalPresentationStyle = .pageSheet
        if let sheet = colorSheetVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]  // 지원 크기 지정
            //sheet.delegate = self
            sheet.prefersGrabberVisible = true  // 상단에 그래버 표시
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        
        present(colorSheetVC, animated: true)
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func descButtonTapped(){
        flowerDescToggleButton.isSelected.toggle()
        flowerDescContentLabel.numberOfLines = flowerDescToggleButton.isSelected ? 0 : 2
    }
}

// MARK: - Extensions
extension FlowerDetailViewController: UIScrollViewDelegate {
    // scrollView가 스와이프 될 때 발생 될 이벤트
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
        imagePageControl.currentPage = currentPage
    }
}

extension FlowerDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2  // TODO: api 연결 후 수정
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManagementCell.identifier, for: indexPath) as? ManagementCell else{
            return UICollectionViewCell()
        }
        cell.prepare(image: UIImage(named: "ManageImage.png"))
        return cell
    }
    
}
    
extension FlowerDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ManagementView.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ManagementView.minimumLineSpacing
    }
}

extension FlowerDetailViewController: UIGestureRecognizerDelegate {}
