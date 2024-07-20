//
//  TodaysFlowerViewCell.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/15/24.
//

import UIKit

final class TodaysFlowerViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TodaysFlowerViewCell"
    var buttonCallbackMethod: (() -> Void)?
    var flowerId: Int?
    
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
        label.font = .Pretendard(size: 14, family: .Medium)
        label.textColor = UIColor.gray07
        return label
    }()
    
    private lazy var flowerOneLineDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(size: 18, family: .Bold)
        label.textColor = UIColor.primary
        return label
    }()
    
    private lazy var flowerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.secondary04
        label.font = .Pretendard(size: 24, family: .Bold)
        return label
    }()
    
    private let flowerLanguageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 1
        return stackView
    }()
    
    private let todaysFlowerButton: CustomButton = {
        let button = CustomButton(buttonType: .todaysFlower)
        button.addTarget(self, action: #selector(goToFlowerDetail), for: .touchUpInside)
        return button
    }()
    
    private let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.gray02
        self.layer.borderColor = UIColor.gray03.cgColor
        self.layer.borderWidth = 1
        
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func goToFlowerDetail() {
        buttonCallbackMethod?()
    }
    
    // MARK: - Functions
    
    private func addViews() {
        addSubview(todaysFlowerLabel)
        addSubview(todaysFlowerStackView)
        addSubview(flowerLanguageStackView)
        addSubview(flowerImageView)
        addSubview(todaysFlowerButton)

        todaysFlowerStackView.addArrangedSubview(flowerOneLineDescriptionLabel)
        todaysFlowerStackView.addArrangedSubview(flowerNameLabel)
    }
    
    private func setupConstraints() {
        todaysFlowerLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(26)
        }
        
        todaysFlowerStackView.snp.makeConstraints { make in
            make.top.equalTo(todaysFlowerLabel.snp.bottom).offset(17)
            make.leading.equalTo(todaysFlowerLabel.snp.leading)
        }
        
        flowerLanguageStackView.snp.makeConstraints { make in
            make.leading.equalTo(todaysFlowerStackView.snp.leading)
            make.top.equalTo(todaysFlowerStackView.snp.bottom).offset(11)
        }
        
        todaysFlowerButton.snp.makeConstraints { make in
            make.leading.equalTo(flowerLanguageStackView.snp.leading)
            make.trailing.equalTo(flowerImageView.snp.leading).offset(-21)
            make.top.equalTo(flowerLanguageStackView.snp.bottom).offset(15)
        }

        flowerImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalTo(todaysFlowerStackView.snp.trailing)
            make.width.equalTo(flowerImageView.snp.height).multipliedBy(2.0 / 3.0)
        }
    }
    
    func configure(_ model: TodaysFlowerModel) {
        flowerId = model.flowerId
        flowerNameLabel.text = model.flowerName
        flowerNameLabel.setLetterSpacing(0.02)
        
        let description = model.flowerOneLineDescription?.split(separator: ",")
        flowerOneLineDescriptionLabel.text = String((description![0]))
        flowerOneLineDescriptionLabel.setLetterSpacing(0.02)
        
        if let imagePath = model.flowerImage {
            ImageProvider.shared.setImage(into: flowerImageView, from: imagePath)
        }
        
        if let flowerLanguage = model.flowerExpressions?[0].flowerLanguage {
            let languageList = flowerLanguage.split(separator: ",").map({ "#" + String($0).trimmingCharacters(in: .whitespaces) })
            
            let languageLabelList: [UILabel] = languageList.map {
                let label = UILabel()
                label.text = $0
                label.font = .Pretendard(family: .Medium)
                label.textColor = UIColor.gray06
                label.sizeToFit()
                return label
            }
                        
            self.layoutSubviews()
            let stackViewWidth = self.todaysFlowerStackView.frame.width
            
            var widthSum: CGFloat = 0
            for label in languageLabelList {
                if label.frame.width + widthSum <= stackViewWidth {
                    widthSum += label.frame.width
                    self.flowerLanguageStackView.addArrangedSubview(label)
                }
            }
        }
    }
}
