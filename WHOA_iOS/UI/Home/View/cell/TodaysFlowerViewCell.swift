//
//  TodaysFlowerViewCell.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/15/24.
//

import UIKit

class TodaysFlowerViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "TodaysFlowerViewCell"
    var buttonCallbackMethod: (() -> Void)?
    
    // MARK: - Views
    private let todaysFlowerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        return stackView
    }()
    
    private let todaysFlowerLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 추천 꽃"
        label.font = UIFont(name: "Pretendard-Bold", size: 14)
        label.textColor = UIColor.primary
        return label
    }()
    
    private lazy var flowerNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont(name: "Pretendard-Bold", size: 24.0)
        return label
    }()
    
    private let flowerLanguageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private let flowerLanguageLabel1: UILabel = {
        let label = UILabel()
        label.text = "#유희"
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = UIColor.gray06
        return label
    }()
    
    private let flowerLanguageLabel2: UILabel = {
        let label = UILabel()
        label.text = "#단아함"
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = UIColor.gray06
        return label
    }()
    
    private let flowerLanguageLabel3: UILabel = {
        let label = UILabel()
        label.text = "#겸손한 사랑"
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = UIColor.gray06
        return label
    }()
    
    private let todaysFlowerButton: CustomButton = {
        let button = CustomButton(buttonType: .todaysFlower)
        button.addTarget(self, action: #selector(goToFlowerDetail), for: .touchUpInside)
        return button
    }()
    
    private let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "FlowerImage.png")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.gray02
        self.layer.borderColor = UIColor.gray03.cgColor
        self.layer.borderWidth = 1
        
        addAttributeToFlowerName(name: "봄 향기를 품은 꽃\n히아신스")
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func goToFlowerDetail(){
        buttonCallbackMethod?()
    }
    
    // MARK: - Helpers
    private func addViews(){
        addSubview(todaysFlowerStackView)
        addSubview(flowerImageView)
        addSubview(todaysFlowerButton)

        todaysFlowerStackView.addArrangedSubview(todaysFlowerLabel)
        todaysFlowerStackView.addArrangedSubview(flowerNameLabel)
        todaysFlowerStackView.addArrangedSubview(flowerLanguageStackView)
        
        [flowerLanguageLabel1, flowerLanguageLabel2, flowerLanguageLabel3].forEach {
            flowerLanguageStackView.addArrangedSubview($0)
        }
        
    }
    
    private func setupConstraints(){
        todaysFlowerStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(26)
        }
        
        todaysFlowerButton.snp.makeConstraints { make in
            make.leading.equalTo(todaysFlowerStackView.snp.leading)
            make.top.equalTo(todaysFlowerStackView.snp.bottom).offset(23)
        }

        flowerImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(flowerImageView.snp.height).multipliedBy(2.0 / 3.0)
        }
    }
    
    private func addAttributeToFlowerName(name: String){
        let array = name.split(separator: "\n")
        let attributeText = NSMutableAttributedString(string: name)
        let range0 = (name as NSString).range(of: String(array[0]))
        let range1 = (name as NSString).range(of: String(array[1]))
        attributeText.addAttribute(.foregroundColor, value: UIColor.primary, range: range0)
        attributeText.addAttribute(.foregroundColor, value: UIColor.secondary04, range: range1)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        attributeText.addAttribute(.paragraphStyle,
                                   value: style,
                                   range: NSRange(location: 0, length: attributeText.length))
        flowerNameLabel.attributedText = attributeText
    }
}
