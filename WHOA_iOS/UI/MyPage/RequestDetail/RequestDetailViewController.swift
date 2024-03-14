//
//  RequestDetailViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/4/24.
//

import UIKit

class RequestDetailViewController: UIViewController {
    // MARK: - Properties
    private var requestTitle: String!
//    private var viewModel: RequestDetailViewModel!
    
    // MARK: - Views
//    private let backButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "xmark"), for: .normal)
//        button.isEnabled = true
//        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        return button
//    }()
    
    lazy var viewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = requestTitle
        label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
        label.textAlignment = .left
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let buyingIntentStackView = RequestDetailStackView()
    
    private let buyingIntentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "구매 목적"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    
    private let buyingIntentContentLabel: DetailCustomLabel = {
        let label = DetailCustomLabel()
        label.text = "생일/생신"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)  // gray03
        return label
    }()
    
    private let borderLine1 = BorderLine()
    
    private let flowerColorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .leading
        return stackView
    }()
    
    private let flowerColorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃 색감"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    
    private let flowerColorContentLabel: DetailCustomLabel = {
        let label = DetailCustomLabel()
        label.text = "포인트컬러"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)  // gray03
        return label
    }()
    
    private let flowerColorChipStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // 포인트 컬러일 경우 해당 컬러의 중앙에 추가할 별 아이콘
    private let starIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "StarIcon")
        return imageView
    }()
    
    private let flowerColorChipView1: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let flowerColorChipView2: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let borderLine2 = BorderLine()
    
    private let flowerTypeStackView = RequestDetailStackView()
    
    private let flowerTypeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃 종류"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    
    private let flowerTypeView1: FlowerTypeView = {
        let view = FlowerTypeView()
        return view
    }()
    
    private let flowerTypeView2: FlowerTypeView = {
        let view = FlowerTypeView()
        return view
    }()
    
    private let borderLine3 = BorderLine()
    
    private let alternativesStackView = RequestDetailStackView()
    
    private let alternativesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "대체"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    
    private let alternativesContentLabel: DetailCustomLabel = {
        let label = DetailCustomLabel()
        label.text = "색감 위주"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)  // gray03
        return label
    }()
    
    private let borderLine4 = BorderLine()
    
    private let wrappingStackView = RequestDetailStackView()
    
    private let wrappingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "포장지"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    
    private let wrappingContentLabel: DetailCustomLabel = {
        let label = DetailCustomLabel()
        label.text = "사장님께 맡길게요"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)  // gray03
        return label
    }()
    
    private let borderLine5 = BorderLine()
    
    private let priceStackView = RequestDetailStackView()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가격"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    
    private let priceContentLabel: DetailCustomLabel = {
        let label = DetailCustomLabel()
        label.text = "20,000~30,000원"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)  // gray03
        return label
    }()
    
    private let borderLine6 = BorderLine()
    
    private let additionalRequirementStackView = RequestDetailStackView()
    
    private let additionalRequirementTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "추가 요구사항과 참고사진"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    
    private let additionalRequirementContentLabel: DetailCustomLabel = {
        let label = DetailCustomLabel()
        label.text = "이쁘게 잘 만들어주세요! 감사합니다 :)"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)  // gray03
        return label
    }()
    
    private let referenceImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()
    
    // 이미지는 최대 3개
    private let referenceImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "WhoaLogo")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = UIColor(red: 233/255, green: 233/255, blue: 235/255, alpha: 1).cgColor  // gray04
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let referenceImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "WhoaLogo")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = UIColor(red: 233/255, green: 233/255, blue: 235/255, alpha: 1).cgColor  // gray04
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let saveAsImageButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)  // primary
        config.baseForegroundColor = UIColor(red: 249/255, green: 249/255, blue: 251/255, alpha: 1)
        config.attributedTitle = AttributedString("이미지로 저장하기", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont(name: "Pretendard-SemiBold", size: 16)!]))
        config.background.cornerRadius = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 117.5, bottom: 17, trailing: 117.5)
        
        button.configuration = config
        button.addTarget(self, action: #selector(saveAsImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    init(requestTitle: String!) {
        super.init(nibName: nil, bundle: nil)
        
        self.requestTitle = requestTitle
//        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    init(viewModel: RequestDetailViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigation()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Helpers
    private func setupNavigation(){
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = requestTitle
        self.navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Pretendard-SemiBold", size: 18)!]
    }
    
    private func addViews(){
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(buyingIntentStackView)
        buyingIntentStackView.addArrangedSubview(buyingIntentTitleLabel)
        buyingIntentStackView.addArrangedSubview(buyingIntentContentLabel)
        contentView.addSubview(borderLine1)
        
        contentView.addSubview(flowerColorStackView)
        flowerColorStackView.addArrangedSubview(flowerColorTitleLabel)
        flowerColorStackView.addArrangedSubview(flowerColorContentLabel)
        flowerColorStackView.addArrangedSubview(flowerColorChipStackView)
        flowerColorChipStackView.addArrangedSubview(flowerColorChipView1)
        flowerColorChipStackView.addArrangedSubview(flowerColorChipView2)
        flowerColorChipView1.addSubview(starIcon)  // 포인트 컬러 칩에 별 추가
        contentView.addSubview(borderLine2)
        
        contentView.addSubview(flowerTypeStackView)
        flowerTypeStackView.addArrangedSubview(flowerTypeTitleLabel)
        flowerTypeStackView.addArrangedSubview(flowerTypeView1)
        flowerTypeStackView.addArrangedSubview(flowerTypeView2)
        contentView.addSubview(borderLine3)
        
        contentView.addSubview(alternativesStackView)
        alternativesStackView.addArrangedSubview(alternativesTitleLabel)
        alternativesStackView.addArrangedSubview(alternativesContentLabel)
        contentView.addSubview(borderLine4)
        
        contentView.addSubview(wrappingStackView)
        wrappingStackView.addArrangedSubview(wrappingTitleLabel)
        wrappingStackView.addArrangedSubview(wrappingContentLabel)
        contentView.addSubview(borderLine5)
     
        contentView.addSubview(priceStackView)
        priceStackView.addArrangedSubview(priceTitleLabel)
        priceStackView.addArrangedSubview(priceContentLabel)
        contentView.addSubview(borderLine6)
        
        contentView.addSubview(additionalRequirementStackView)
        additionalRequirementStackView.addArrangedSubview(additionalRequirementTitleLabel)
        additionalRequirementStackView.addArrangedSubview(additionalRequirementContentLabel)
        additionalRequirementStackView.addArrangedSubview(referenceImageStackView)
        referenceImageStackView.addArrangedSubview(referenceImageView1)
        referenceImageStackView.addArrangedSubview(referenceImageView2)
        
        contentView.addSubview(saveAsImageButton)
    }
    
    private func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(4)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
//            make.height.equalToSuperview()
        }
        
        buyingIntentStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.leading.equalToSuperview().inset(45)
        }
        
        borderLine1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(buyingIntentStackView.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        flowerColorStackView.snp.makeConstraints { make in
            make.top.equalTo(borderLine1.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(45)
        }
        
        flowerColorChipView1.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(flowerColorChipView1.snp.height).multipliedBy(1)
        }
        
        starIcon.snp.makeConstraints { make in
//            make.center.equalToSuperview()
            make.edges.equalToSuperview().inset(9)
        }
        
        flowerColorChipView2.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(flowerColorChipView2.snp.height).multipliedBy(1)
        }
        
        borderLine2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(flowerColorStackView.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        flowerTypeStackView.snp.makeConstraints { make in
            make.top.equalTo(borderLine2.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(45)
        }
        
        borderLine3.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(flowerTypeStackView.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        alternativesStackView.snp.makeConstraints { make in
            make.top.equalTo(borderLine3.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(45)
        }
        
        borderLine4.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(alternativesStackView.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        wrappingStackView.snp.makeConstraints { make in
            make.top.equalTo(borderLine4.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(45)
        }
        
        borderLine5.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(wrappingStackView.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        priceStackView.snp.makeConstraints { make in
            make.top.equalTo(borderLine5.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(45)
        }
        
        borderLine6.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(priceStackView.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        additionalRequirementStackView.snp.makeConstraints { make in
            make.top.equalTo(borderLine6.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(45)
        }
        
        referenceImageView1.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(referenceImageView1.snp.width).multipliedBy(1)
        }
        
        referenceImageView2.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(referenceImageView2.snp.width).multipliedBy(1)
        }
        
        saveAsImageButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(additionalRequirementStackView.snp.bottom).offset(32)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    // MARK: - Actions
    
    @objc func saveAsImageButtonTapped(){
        print("이미지로 저장")
    }
}

// MARK: - Extension; ScrollView
extension RequestDetailViewController: UIScrollViewDelegate {
    
}
