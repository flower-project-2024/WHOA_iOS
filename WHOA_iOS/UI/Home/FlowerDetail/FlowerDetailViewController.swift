//
//  FlowerDetailViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/9/24.
//

import UIKit

class FlowerDetailViewController: UIViewController {
    // MARK: - Properties
    
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
    
    var colorButtonList: [ColorChipButton] = []
    var imageList: [String] = []
    
    private let colorChipStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
     //   stackView.distribution = .
        return stackView
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageList = ["1", "2", "3"]
        
        view.backgroundColor = .white
        
        self.navigationItem.title = "히아신스"
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        
        imageScrollView.delegate = self
        
        generateColorChipButtons()
        
        addSubViews()
        setupConstraints()
        setPageControlCount(imageList.count)
        setScrollViewContent(images: ["1", "2", "3"])  // 스크롤뷰에 이미지 세팅
    }
    
    // MARK: - Functions
    private func addSubViews(){
        // add views
        view.addSubview(imageScrollView)
        view.addSubview(imagePageControl)
        view.addSubview(flowerNameLabel)
        view.addSubview(flowerDescriptionLabel)
        view.addSubview(flowerLanguageLabel)
        view.addSubview(flowerLanguageContentLabel)
        view.addSubview(colorLabel)
        view.addSubview(colorChipStackView)
        
        // add colorChipButtons to colorChipStackView
        colorButtonList.forEach({ button in
            button.snp.makeConstraints { make in
                make.width.equalTo(20)
                make.height.equalTo(20)
            }
            print(button)
            colorChipStackView.addArrangedSubview(button)
        })
    }
    
    private func setupConstraints(){
        imageScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(250)
            make.leading.trailing.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
        }
        imagePageControl.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        flowerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imagePageControl.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        flowerDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(flowerNameLabel.snp.bottom).offset(15)
            make.leading.equalTo(flowerNameLabel.snp.leading)
            make.trailing.equalToSuperview().inset(20)
        }
        
//        stackView.snp.makeConstraints { make in
//            make.top.equalTo(flowerDescriptionLabel.snp.bottom).offset(15)
//            make.leading.equalTo(flowerDescriptionLabel.snp.leading)
//        }
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
