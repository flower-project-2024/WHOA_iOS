//
//  FlowerDetailViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/9/24.
//

import UIKit

class FlowerDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    static private let flowerLanguageInterItemSpacing: CGFloat = 6
    var colorButtonList: [ColorChipButton] = []
    private var flowerId: Int
    private let viewModel = FlowerDetailViewModel()
    
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
        label.font = .Pretendard(size: 18, family: .SemiBold)
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
        label.font = .Pretendard(size: 24, family: .SemiBold)
        label.textColor = UIColor.primary
        return label
    }()
    
    private let flowerEnglishNameLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(size: 16)
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
        label.font = .Pretendard(size: 20, family: .Bold)
        label.textColor = UIColor.secondary04
        return label
    }()
    
    private lazy var flowerDescContentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2  // 초기 줄 수는 2 (접은 상태)
        label.lineBreakMode = .byCharWrapping
        label.font = .Pretendard(size: 16)
        label.textColor = UIColor(red: 66/255, green: 66/255, blue: 68/255, alpha: 1)
        return label
    }()
    
    private let flowerDescToggleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .Pretendard(size: 16, family: .Bold)
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
        label.font = .Pretendard(size: 20, family: .Bold)
        label.textColor = UIColor.primary
        return label
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
        label.font = .Pretendard(size: 16, family: .Bold)
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
    
    private let colorChipDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "색상 별 다양한 꽃말을 확인해보세요"
        label.font = .Pretendard(size: 16)
        label.textColor = .gray06
        return label
    }()
    
    private let birthFlowerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
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
        label.font = .Pretendard(size: 16, family: .Bold)
        label.textColor = UIColor.primary
        return label
    }()
    
    private lazy var flowerLanguageContentCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = FlowerDetailViewController.flowerLanguageInterItemSpacing
        flowLayout.minimumLineSpacing = FlowerDetailViewController.flowerLanguageInterItemSpacing
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0,
                                         left: 28,
                                         bottom: 0,
                                         right: 28)
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.automaticallyAdjustsScrollIndicatorInsets = false
        
        view.delegate = self
        view.dataSource = self
        view.register(FlowerLanguageCell.self, forCellWithReuseIdentifier: FlowerLanguageCell.identifier)
        return view
    }()
    
    private let borderLine2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        return view
    }()
    
    private let birthFlowerLabel: UILabel = {
        let label = UILabel()
        label.text = "탄생화"
        label.font = .Pretendard(size: 16, family: .Bold)
        label.textColor = UIColor.primary
        return label
    }()
    
    private let birthFlowerDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
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
    
    // MARK: - Lifecycle
    
    init(flowerId: Int) {
        self.flowerId = flowerId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        bind()
        viewModel.fetchFlowerDetail(flowerId: flowerId, fromCurrentVC: self)
        
        imageScrollView.delegate = self
        
        decorateButton.addTarget(self, action: #selector(decorateBtnTapped), for: .touchUpInside)
        
        setupNavigation()
        
        addSubViews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupCollectionView()
    }
    
    // MARK: - Functions
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.topItem?.title = ""
        
        let backbutton = UIBarButtonItem(image: UIImage.chevronLeft, style: .done, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = backbutton
        
        // left bar button을 추가하면 기존에 되던 스와이프 pop 기능이 해제됨
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setupNavigationTitle() {
        titleView.text = viewModel.getFlowerName()
        self.navigationItem.titleView = titleView
    }
    
    private func setupCollectionView() {
        managementView.collectionView.delegate = self
        managementView.collectionView.dataSource = self
        
        managementView.collectionView.register(ManagementCell.self, forCellWithReuseIdentifier: ManagementCell.identifier)
        
        managementView.collectionView.contentInset = UIEdgeInsets(top: 0,
                                                                  left: ManagementView.minimumLineSpacing * 2,
                                                                  bottom: 0,
                                                                  right: ManagementView.minimumLineSpacing)
    }
    
    private func addSubViews() {
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
        outerScrollView.addSubview(flowerColorStackView)
        outerScrollView.addSubview(borderLine1)
        outerScrollView.addSubview(flowerLanguageLabel)
        outerScrollView.addSubview(flowerLanguageContentCollectionView)
        outerScrollView.addSubview(borderLine2)
        outerScrollView.addSubview(birthFlowerStackView)
        outerScrollView.addSubview(managementView)
        
        [flowerKoreanNameLabel, flowerEnglishNameLabel].forEach {
            flowerNameStackView.addArrangedSubview($0)
        }
        
        [flowerColorLabel, flowerColorChipHStackView, colorChipDescriptionLabel].forEach {
            flowerColorStackView.addArrangedSubview($0)
        }
        
        [birthFlowerLabel, birthFlowerDateStackView].forEach {
            birthFlowerStackView.addArrangedSubview($0)
        }
        
        bottomFixedView.addSubview(decorateButton)
    }
    
    private func setupConstraints() {
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

        flowerColorStackView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(27)
            make.leading.equalToSuperview().inset(28)
        }
        
        borderLine1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
            make.top.equalTo(flowerColorStackView.snp.bottom).offset(22)
        }
        
        flowerLanguageLabel.snp.makeConstraints { make in
            make.leading.equalTo(flowerColorStackView.snp.leading)
            make.top.equalTo(borderLine1.snp.bottom).offset(22)
        }
        
        flowerLanguageContentCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(flowerLanguageLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview()
            make.height.equalTo(32)
        }
        
        borderLine2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
            make.top.equalTo(flowerLanguageContentCollectionView.snp.bottom).offset(22)
        }
        
        birthFlowerStackView.snp.makeConstraints { make in
            make.top.equalTo(borderLine2.snp.bottom).offset(22)
            make.leading.equalTo(flowerLanguageLabel.snp.leading)
            make.trailing.equalToSuperview().inset(15)
        }
        
        managementView.snp.makeConstraints { make in
            make.top.equalTo(birthFlowerStackView.snp.bottom).offset(40)
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
    
    private func generateColorChipButtons(_ colors: [String]?) {
        if let colors = colors {
            for color in colors {
                colorButtonList.append(ColorChipButton(colorCode: color))
            }
        }
        
        // add colorChipButtons to flowerColorChipHStackView
        colorButtonList.forEach({ button in
            button.addTarget(self, action: #selector(colorChipButtonTapped(sender:)), for: .touchUpInside)
            
            button.snp.makeConstraints { make in
                make.width.equalTo(27.93)
                make.height.equalTo(27.93)
            }
            flowerColorChipHStackView.addArrangedSubview(button)
        })
    }
    
    private func setPageControlCount(_ pages: Int) {
        imagePageControl.numberOfPages = pages
    }
    
    /// scrolliVew에 imageView 추가하는 함수
    private func setScrollViewContent(images: [String]) {
        view.setNeedsLayout()  // 정확한 크기를 얻기 위해
        view.layoutIfNeeded()
        
        for index in 0 ..< images.count {
            let imageView = UIImageView()
            ImageProvider.shared.setImage(into: imageView, from: images[index])
            
            let xPosition = imageScrollView.frame.width * CGFloat(index)
            
            imageView.frame = CGRect(x: xPosition,
                                     y: 0,
                                     width: imageScrollView.bounds.width,
                                     height: imageScrollView.bounds.height)
            imageView.contentMode = .scaleAspectFit
            imageScrollView.addSubview(imageView)
            
            imageScrollView.contentSize.width = imageView.frame.width * CGFloat(index+1)
        }
    }
    
    private func setBirthFlowerData(_ dates: [String]?) {
        if let dates = dates {
            for date in dates {
                let label = HashTagCustomLabel(padding: .init(top: 6, left: 12, bottom: 6, right: 12))
                label.layer.cornerRadius = 16
                label.text = date
                label.font = .Pretendard()
                label.backgroundColor = .gray03
                birthFlowerDateStackView.addArrangedSubview(label)
            }
            
        }
        else {
            let label = HashTagCustomLabel(padding: .init(top: 6, left: 12, bottom: 6, right: 12))
            label.text = "탄생일 없음"
            label.layer.cornerRadius = 16
            label.font = .Pretendard()
            label.backgroundColor = .gray03
            birthFlowerDateStackView.addArrangedSubview(label)
        }
    }
    
    private func bind() {
        viewModel.flowerDetailDidChange = { [weak self] in
            DispatchQueue.main.async {
                self?.setupNavigationTitle()
                self?.setPageControlCount((self?.viewModel.getFlowerImageCount())!)
                self?.setScrollViewContent(images: (self?.viewModel.getFlowerImages())!)  // 스크롤뷰에 이미지 세팅
                self?.flowerKoreanNameLabel.text = self?.viewModel.getFlowerName()
                self?.flowerDescTitleLabel.text = self?.viewModel.getFlowerOneLineDesc()
                self?.flowerDescContentLabel.text = self?.viewModel.getFlowerDesc()
                self?.flowerDescContentLabel.setLineHeight(lineHeight: 150)
                self?.setBirthFlowerData(self?.viewModel.getBirthFlowerDates())
                self?.generateColorChipButtons(self?.viewModel.getFlowerColors())
                self?.managementView.collectionView.reloadData()
                self?.flowerLanguageContentCollectionView.reloadData()
                self?.selectFirstColorChipButton()
            }
        }
        
        viewModel.colorChipDidChanged = { [weak self] in
            self?.flowerLanguageContentCollectionView.reloadData()
        }
    }
    
    private func selectFirstColorChipButton() {
        if let firstButton = colorButtonList.first {
            colorChipButtonTapped(sender: firstButton)
        }
    }
    
    // MARK: - Actions
    
    @objc func decorateBtnTapped() {
        let colorSheetVC = ColorSheetViewController(viewModel: viewModel)
        
        colorSheetVC.modalPresentationStyle = .pageSheet
        if let sheet = colorSheetVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.selectedDetentIdentifier = .medium
            sheet.preferredCornerRadius = 20
        }
        present(colorSheetVC, animated: true)
    }
    
    @objc func colorChipButtonTapped(sender: UIButton?) {
        colorButtonList.forEach { button in
            if button == sender {
                button.setImage(UIImage(named: "Checkmark"), for: .normal)
                guard let hexString = button.configuration?.background.backgroundColor?.toHexString() else { return }
                viewModel.setFlowerExpression(hexString: hexString)
            } else {
                button.configuration?.image = nil
            }
        }
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func descButtonTapped() {
        flowerDescToggleButton.isSelected.toggle()
        flowerDescContentLabel.numberOfLines = flowerDescToggleButton.isSelected ? 0 : 2
    }
}

// MARK: - Extensions: UIScrollView

extension FlowerDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
        imagePageControl.currentPage = currentPage
    }
}

// MARK: - Extensions: UICollectionView

extension FlowerDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == flowerLanguageContentCollectionView {
            return viewModel.getSelectedFlowerLanguageCount()
        }
        else {
            return viewModel.getFlowerManagementCellCount()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == flowerLanguageContentCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlowerLanguageCell.identifier, for: indexPath) as? FlowerLanguageCell else { return UICollectionViewCell() }
            
            cell.configure(viewModel.getFlowerLanguagesAt(index: indexPath.item))
            return cell
        }
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManagementCell.identifier, for: indexPath) as? ManagementCell else{
                return UICollectionViewCell()
            }
            
            let method = viewModel.getFlowerMethodDetailAt(index: indexPath.item)
            
            cell.prepare(image: method[0].getFlowerManagementImage())
            cell.configure(content: method)
            
            return cell
        }
    }
    
}

extension FlowerDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == flowerLanguageContentCollectionView {
            let label = UILabel()
            label.text = viewModel.getFlowerLanguagesAt(index: indexPath.item)
            label.font = .Pretendard()
            label.sizeToFit()
            
            let cellWidth = label.frame.width + 24
            let cellHeight = label.frame.height + 12
            
            return CGSize(width: cellWidth, height: cellHeight)
        }
        else {
            return ManagementView.cellSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == flowerLanguageContentCollectionView {
            return FlowerDetailViewController.flowerLanguageInterItemSpacing
        }
        else {
            return ManagementView.minimumLineSpacing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == flowerLanguageContentCollectionView {
            return FlowerDetailViewController.flowerLanguageInterItemSpacing
        }
        else {
            return ManagementView.minimumLineSpacing
        }
    }
}

// MARK: - Extension: UIGestureRecognizer

extension FlowerDetailViewController: UIGestureRecognizerDelegate {}
