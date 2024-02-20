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
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.hidesForSinglePage = true
        return pageControl
    }()

    private let flowerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "히아신스"
        label.font = UIFont(name: "Pretendard-Bold", size: 23)
        return label
    }()
    
    private let flowerDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "무게감 있는 진한 향이 오래도록 퍼져나가, 영원한 사랑을 전하기에 제격이에요."
        label.font = UIFont(name: "Pretendard-Regular", size: 17)
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let flowerLanguageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 40
        return stackView
    }()
    
    private let flowerLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃말"
        return label
    }()
    
    private let flowerLanguageContentLabel: UILabel = {
        let label = UILabel()
        label.text = "사랑 고백"
        return label
    }()
    
    private let colorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 40
        stackView.alignment = .center
        return stackView
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "색상"
        return label
    }()
    
    private let colorChipStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
     //   stackView.distribution = .
        return stackView
    }()
    
    private let birthFlowerLabel: UILabel = {
        let label = UILabel()
        label.text = "탄생화"
        return label
    }()
    
    private let birthFlowerDateLabel: UILabel = {
        let label = UILabel()
        label.text = "8월 15일"
        return label
    }()
    
    private let detailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 34
        return stackView
    }()
    
    private let viewTermStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .top
        return stackView
    }()
    
    private let viewTermImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private let viewTermContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private let viewTermTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.text = "관상기간"
        return label
    }()
    
    private let viewTermContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.text = "5~14일"
        return label
    }()
    
    private let waterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .top
        return stackView
    }()
    
    private let waterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .green
        return imageView
    }()
    
    private let waterContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private let waterTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.text = "탈수 잦음"
        return label
    }()
    
    private let waterContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.text = "탈수현상이 쉽게 나타나므로 물올림을 충분히 한 후에 꽂아주세요"
        label.numberOfLines = 0
        return label
    }()
    
    private let usageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .top
        return stackView
    }()
    
    private let usageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    private let usageContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    private let usageTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 16)
        label.text = "드라이플라워"
        return label
    }()
    
    private let usageContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.text = "거꾸로 매달아 말리면 드라이플라워로 활용할 수 있어요"
        label.numberOfLines = 0
        return label
    }()
    
    private let decorateButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.title = "이 꽃으로 꾸미기"
        config.attributedTitle?.font = UIFont(name: "Pretendard-Bold", size: 20.0)
        config.background.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1.00)
        config.background.cornerRadius = 10
        config.contentInsets = .init(top: 15, leading: 15, bottom: 15, trailing: 15)
        button.configuration = config
        return button
    }()
    
    // MARK: - Properties
    var colorButtonList: [ColorChipButton] = []
    var imageList: [String] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageList = ["1", "2", "3"]
        
        view.backgroundColor = .white
        
        self.navigationItem.title = "히아신스"
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        
        imageScrollView.delegate = self
        outerScrollView.delegate = self
        
        decorateButton.addTarget(self, action: #selector(decorateBtnTapped), for: .touchUpInside)
        
        generateColorChipButtons()
        
        addSubViews()
        setupConstraints()
        setPageControlCount(imageList.count)
        setScrollViewContent(images: ["1", "2", "3"])  // 스크롤뷰에 이미지 세팅
    }
    
    // MARK: - Functions
    private func addSubViews(){
        // add views
        view.addSubview(outerScrollView)
        
        outerScrollView.addSubview(imageScrollView)
        outerScrollView.addSubview(imagePageControl)
        outerScrollView.addSubview(flowerNameLabel)
        outerScrollView.addSubview(flowerDescriptionLabel)
        outerScrollView.addSubview(flowerLanguageLabel)
        outerScrollView.addSubview(flowerLanguageContentLabel)
        outerScrollView.addSubview(colorLabel)
        outerScrollView.addSubview(colorChipStackView)
        outerScrollView.addSubview(birthFlowerLabel)
        outerScrollView.addSubview(birthFlowerDateLabel)
        outerScrollView.addSubview(detailStackView)
        outerScrollView.addSubview(decorateButton)
        
        // add colorChipButtons to colorChipStackView
        colorButtonList.forEach({ button in
            button.snp.makeConstraints { make in
                make.width.equalTo(20)
                make.height.equalTo(20)
            }
            print(button)
            colorChipStackView.addArrangedSubview(button)
        })
        
        [viewTermStackView, waterStackView, usageStackView].forEach {
            detailStackView.addArrangedSubview($0)
        }
        
        [viewTermImageView, viewTermContentStackView].forEach {
            viewTermStackView.addArrangedSubview($0)
        }
        
        [waterImageView, waterContentStackView].forEach {
            waterStackView.addArrangedSubview($0)
        }
        
        [usageImageView, usageContentStackView].forEach {
            usageStackView.addArrangedSubview($0)
        }
        
        [viewTermTitleLabel, viewTermContentLabel].forEach {
            viewTermContentStackView.addArrangedSubview($0)
        }
        
        [waterTitleLabel, waterContentLabel].forEach {
            waterContentStackView.addArrangedSubview($0)
        }
        
        [usageTitleLabel, usageContentLabel].forEach {
            usageContentStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints(){
        outerScrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }
        
        imageScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(250)
            make.leading.trailing.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
        
        flowerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        flowerDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(flowerNameLabel.snp.bottom).offset(15)
            make.leading.equalTo(flowerNameLabel.snp.leading)
            make.trailing.equalToSuperview().inset(20)
        }
        
        flowerLanguageLabel.snp.makeConstraints { make in
            make.top.equalTo(flowerDescriptionLabel.snp.bottom).offset(15)
            make.leading.equalTo(flowerDescriptionLabel.snp.leading)
        }
        
        flowerLanguageContentLabel.snp.makeConstraints { make in
            make.leading.equalTo(flowerLanguageLabel.snp.trailing).offset(40)
            make.centerY.equalTo(flowerLanguageLabel.snp.centerY)
        }
        
        colorLabel.snp.makeConstraints { make in
            make.top.equalTo(flowerLanguageLabel.snp.bottom).offset(15)
            make.leading.equalTo(flowerLanguageLabel.snp.leading)
        }
        
        colorChipStackView.snp.makeConstraints { make in
            make.leading.equalTo(flowerLanguageContentLabel.snp.leading)
            make.centerY.equalTo(colorLabel.snp.centerY)
        }
        
        birthFlowerLabel.snp.makeConstraints { make in
            make.leading.equalTo(colorLabel.snp.leading)
            make.top.equalTo(colorLabel.snp.bottom).offset(15)
        }
        
        birthFlowerDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(flowerLanguageContentLabel.snp.leading)
            make.centerY.equalTo(birthFlowerLabel.snp.centerY)
        }
        
        imagePageControl.snp.makeConstraints { make in
            make.top.equalTo(birthFlowerDateLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        detailStackView.snp.makeConstraints { make in
            make.top.equalTo(imagePageControl.snp.bottom).offset(45)
            make.leading.trailing.equalToSuperview().inset(30)
        }
        
        viewTermImageView.snp.makeConstraints { make in
            make.width.equalTo(43)
            make.height.equalTo(viewTermImageView.snp.width).multipliedBy(1)
        }
        
        waterImageView.snp.makeConstraints { make in
            make.width.equalTo(43)
            make.height.equalTo(waterImageView.snp.width).multipliedBy(1)
        }
        
        usageImageView.snp.makeConstraints { make in
            make.width.equalTo(43)
            make.height.equalTo(usageImageView.snp.width).multipliedBy(1)
        }
        
        decorateButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.top.equalTo(detailStackView.snp.bottom).offset(103)
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    func generateColorChipButtons(){
        for _ in 0...2 {
            colorButtonList.append(ColorChipButton())
        }
    }
    
    func setPageControlCount(_ pages: Int) {
        imagePageControl.numberOfPages = pages
    }
    
    func setScrollViewContent(images: [String]) { // scrolliVew에 imageView 추가하는 함수
        view.setNeedsLayout()  // 정확한 크기를 얻기 위해
        view.layoutIfNeeded()
        
        for index in 0..<images.count {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "image.png")
            imageView.backgroundColor = .green
            imageView.contentMode = .scaleAspectFit

            print("=== imageScrollView frame ===")
            print(imageScrollView.frame)
            print(imageScrollView.bounds.width)
            
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
        print("===이 꽃으로 꾸미기===")
    }
}

// MARK: - Extensions
extension FlowerDetailViewController: UIScrollViewDelegate {
    // scrollView가 스와이프 될 때 발생 될 이벤트
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
        imagePageControl.currentPage = currentPage
//        self.imageNumberLabel.text = "\(imagePageControl.currentPage)/\(imagePageControl.numberOfPages)"
        // 컬러칩 새로 선택
        
    }
}
