//
//  RequestDetailView.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/19/24.
//

import UIKit

class RequestDetailView: UIView {
    
    // MARK: - Properties
    
    let requestDetailType: RequestDetailType
    
    // MARK: - Views
    
    let requestNameTextField: UITextField = {
        let textField = UITextField()
        textField.frame.size.height = 40
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 6
        textField.layer.masksToBounds = true
        textField.isEnabled = false
        textField.isHidden = true
        return textField
    }()
    
    let requestNameTextFieldPlaceholder: UILabel = {
        let label = UILabel()
        label.text = "꽃다발 요구서1"
        label.textColor = .gray8
        label.font = .Pretendard()
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Edit"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let borderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        return view
    }()
    
    private let buyingIntentStackView = RequestDetailStackView()
    
    private let buyingIntentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "구매 목적"
        label.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        return label
    }()
    
    private let buyingIntentContentLabel: DetailCustomLabel = {
        let label = DetailCustomLabel()
        label.text = "생일/생신"
        label.font = UIFont.Pretendard(size: 14, family: .Regular)
        label.backgroundColor = UIColor.gray03
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
        label.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        return label
    }()
    
    private let flowerColorContentLabel: DetailCustomLabel = {
        let label = DetailCustomLabel()
        label.text = "포인트컬러"
        label.font = UIFont.Pretendard(size: 14, family: .Regular)
        label.backgroundColor = UIColor.gray03
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
        imageView.image = UIImage.starIcon
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
        label.font = UIFont.Pretendard(size: 16, family: .SemiBold)
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
        label.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        return label
    }()
    
    private let alternativesContentLabel: DetailCustomLabel = {
        let label = DetailCustomLabel()
        label.text = "색감 위주"
        label.font = UIFont.Pretendard(size: 14, family: .Regular)
        label.backgroundColor = UIColor.gray03
        return label
    }()
    
    private let borderLine4 = BorderLine()
    
    private let wrappingStackView = RequestDetailStackView()
    
    private let wrappingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "포장지"
        label.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        return label
    }()
    
    private let wrappingContentLabel: DetailCustomLabel = {
        let label = DetailCustomLabel()
        label.text = "사장님께 맡길게요"
        label.font = UIFont.Pretendard(size: 14, family: .Regular)
        label.backgroundColor = UIColor.gray03
        return label
    }()
    
    private let borderLine5 = BorderLine()
    
    private let priceStackView = RequestDetailStackView()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "가격"
        label.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        return label
    }()
    
    private let priceContentLabel: DetailCustomLabel = {
        let label = DetailCustomLabel()
        label.text = "20,000~30,000원"
        label.font = UIFont.Pretendard(size: 14, family: .Regular)
        label.backgroundColor = UIColor.gray03
        return label
    }()
    
    private let borderLine6 = BorderLine()
    
    private let additionalRequirementStackView = RequestDetailStackView()
    
    private let additionalRequirementTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "추가 요구사항과 참고사진"
        label.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        return label
    }()
    
    private let additionalRequirementContentLabel: DetailCustomLabel = {
        let label = DetailCustomLabel()
        label.text = "이쁘게 잘 만들어주세요! 감사합니다 :)"
        label.font = UIFont.Pretendard(size: 14, family: .Regular)
        label.backgroundColor = UIColor.gray03
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
        imageView.image = UIImage.whoaLogo
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = UIColor.gray04.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let referenceImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.whoaLogo
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = UIColor.gray04.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let referenceImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.whoaLogo
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = UIColor.gray04.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    // MARK: -Initialization
    init(requestDetailType: RequestDetailType) {
        self.requestDetailType = requestDetailType
        super.init(frame: .zero)
        
        backgroundColor = .white
        layer.borderColor = UIColor(red: 177/255, green: 177/255, blue: 177/255, alpha: 1).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        addViews()
        setupConstraints()
        setupCustomDetailUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -Helpers
    func config(model: CustomizingSummaryModel) {
        buyingIntentContentLabel.text = model.purpose.rawValue
        
        flowerColorContentLabel.text = model.numberOfColors.rawValue
        flowerColorChipView1.backgroundColor = UIColor(hex: model.colors[0])
        flowerColorChipView2.backgroundColor = UIColor(hex: model.colors[1])
        
        //        flowerTypeView1.flowerImageView.image = model.Flowers[0].photo
        flowerTypeView1.flowerNameLabel.text = model.flowers[0].name
        flowerTypeView1.flowerLanguageTagLabel1.text = model.flowers[0].hashTag[0]
        flowerTypeView1.flowerLanguageTagLabel2.text = model.flowers[0].hashTag[1]
        //        flowerTypeView2.flowerImageView.image = model.Flowers[1].photo
//        flowerTypeView2.flowerNameLabel.text = model.Flowers[1].flowerName
//        flowerTypeView2.flowerLanguageTagLabel1.text = model.Flowers[1].hashTag[0]
//        flowerTypeView2.flowerLanguageTagLabel2.text = model.Flowers[1].hashTag[1]
        
        alternativesContentLabel.text = model.alternative.rawValue
        
        priceContentLabel.text = model.priceRange
        
        additionalRequirementContentLabel.text = model.requirement?.text
        // 요구사항 사진 추가 필요
    }
    
    private func setupCustomDetailUI() {
        if requestDetailType == .custom {
            requestNameTextField.isHidden = false
            editButton.isHidden = false
            borderLine.isHidden = false
        }
    }
    
    private func addViews(){
        addSubview(requestNameTextField)
        requestNameTextField.addSubview(requestNameTextFieldPlaceholder)
        addSubview(editButton)
        addSubview(borderLine)
        
        addSubview(buyingIntentStackView)
        buyingIntentStackView.addArrangedSubview(buyingIntentTitleLabel)
        buyingIntentStackView.addArrangedSubview(buyingIntentContentLabel)
        addSubview(borderLine1)
        
        addSubview(flowerColorStackView)
        flowerColorStackView.addArrangedSubview(flowerColorTitleLabel)
        flowerColorStackView.addArrangedSubview(flowerColorContentLabel)
        flowerColorStackView.addArrangedSubview(flowerColorChipStackView)
        flowerColorChipStackView.addArrangedSubview(flowerColorChipView1)
        flowerColorChipStackView.addArrangedSubview(flowerColorChipView2)
        flowerColorChipView1.addSubview(starIcon)  // 포인트 컬러 칩에 별 추가
        addSubview(borderLine2)
        
        addSubview(flowerTypeStackView)
        flowerTypeStackView.addArrangedSubview(flowerTypeTitleLabel)
        flowerTypeStackView.addArrangedSubview(flowerTypeView1)
        flowerTypeStackView.addArrangedSubview(flowerTypeView2)
        addSubview(borderLine3)
        
        addSubview(alternativesStackView)
        alternativesStackView.addArrangedSubview(alternativesTitleLabel)
        alternativesStackView.addArrangedSubview(alternativesContentLabel)
        addSubview(borderLine4)
        
        addSubview(wrappingStackView)
        wrappingStackView.addArrangedSubview(wrappingTitleLabel)
        wrappingStackView.addArrangedSubview(wrappingContentLabel)
        addSubview(borderLine5)
     
        addSubview(priceStackView)
        priceStackView.addArrangedSubview(priceTitleLabel)
        priceStackView.addArrangedSubview(priceContentLabel)
        addSubview(borderLine6)
        
        addSubview(additionalRequirementStackView)
        additionalRequirementStackView.addArrangedSubview(additionalRequirementTitleLabel)
        additionalRequirementStackView.addArrangedSubview(additionalRequirementContentLabel)
        additionalRequirementStackView.addArrangedSubview(referenceImageStackView)
        referenceImageStackView.addArrangedSubview(referenceImageView1)
        referenceImageStackView.addArrangedSubview(referenceImageView2)
        referenceImageStackView.addArrangedSubview(referenceImageView3)
        
    }
    
    private func setupConstraints(){
        requestNameTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        requestNameTextFieldPlaceholder.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(12)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(requestNameTextField.snp.centerY)
            $0.trailing.equalTo(requestNameTextField.snp.trailing).offset(-12)
        }
        
        borderLine.snp.makeConstraints {
            $0.leading.trailing.equalTo(borderLine1)
            $0.top.equalTo(requestNameTextField.snp.bottom).offset(16)
            $0.height.equalTo(1)
        }
        
        buyingIntentStackView.snp.makeConstraints { make in
            if requestDetailType == .custom {
                make.top.equalTo(borderLine.snp.bottom).offset(28)
            } else {
                make.top.equalToSuperview().inset(28)
            }
            make.leading.equalToSuperview().inset(24)
        }
        
        borderLine1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(17)
            make.top.equalTo(buyingIntentStackView.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        flowerColorStackView.snp.makeConstraints { make in
            make.top.equalTo(borderLine1.snp.bottom).offset(20)
            make.leading.equalTo(buyingIntentStackView)
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
            make.leading.trailing.equalTo(borderLine1)
            make.top.equalTo(flowerColorStackView.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        flowerTypeStackView.snp.makeConstraints { make in
            make.top.equalTo(borderLine2.snp.bottom).offset(20)
            make.leading.equalTo(flowerColorStackView)
        }
        
        borderLine3.snp.makeConstraints { make in
            make.leading.trailing.equalTo(borderLine2)
            make.top.equalTo(flowerTypeStackView.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        alternativesStackView.snp.makeConstraints { make in
            make.top.equalTo(borderLine3.snp.bottom).offset(20)
            make.leading.equalTo(flowerTypeStackView)
        }
        
        borderLine4.snp.makeConstraints { make in
            make.leading.trailing.equalTo(borderLine3)
            make.top.equalTo(alternativesStackView.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        wrappingStackView.snp.makeConstraints { make in
            make.top.equalTo(borderLine4.snp.bottom).offset(20)
            make.leading.equalTo(alternativesStackView)
        }
        
        borderLine5.snp.makeConstraints { make in
            make.leading.trailing.equalTo(borderLine4)
            make.top.equalTo(wrappingStackView.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        priceStackView.snp.makeConstraints { make in
            make.top.equalTo(borderLine5.snp.bottom).offset(20)
            make.leading.equalTo(wrappingStackView)
        }
        
        borderLine6.snp.makeConstraints { make in
            make.leading.trailing.equalTo(borderLine5)
            make.top.equalTo(priceStackView.snp.bottom).offset(20)
            make.height.equalTo(1)
        }
        
        additionalRequirementStackView.snp.makeConstraints { make in
            make.top.equalTo(borderLine6.snp.bottom).offset(20)
            make.leading.equalTo(priceStackView)
            make.bottom.equalToSuperview().inset(28)
        }
        
        referenceImageView1.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(referenceImageView1.snp.width).multipliedBy(1)
        }
        
        referenceImageView2.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(referenceImageView2.snp.width).multipliedBy(1)
        }
        
        referenceImageView3.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(referenceImageView3.snp.width).multipliedBy(1)
        }
    }
}
