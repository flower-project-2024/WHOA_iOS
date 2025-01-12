//
//  TodaysFlowerViewCell2.swift
//  WHOA_iOS
//
//  Created by 김세훈 on 1/11/25.
//

import UIKit

final class TodaysFlowerViewCell2: UICollectionViewCell {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let todaysFlowerButtonHeight: CGFloat = 32
        static let todaysFlowerButtonWidth: CGFloat = 194.0
        static let flowerImageViewWidthMultiplier: CGFloat = 0.38
        static let mainStackViewLeadingOffset: CGFloat = 26
    }
    
    /// Attributes
    private enum Attributes {
        static let todaysFlowerLabelText: String = "오늘의 추천 꽃"
    }
    
    // MARK: - UI
    
    private let todaysFlowerLabel: UILabel = {
        let label = UILabel()
        label.text = Attributes.todaysFlowerLabelText
        label.font = .Pretendard(size: 14, family: .Bold)
        label.textColor = UIColor.customPrimary
        return label
    }()
    
    private let flowerOneLineDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "봄 향기를 품은 꽃"
        label.font = .Pretendard(size: 24, family: .Bold)
        label.textColor = UIColor.customPrimary
        return label
    }()
    
    private let flowerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "히아신스"
        label.textColor = UIColor.secondary04
        label.font = .Pretendard(size: 24, family: .Bold)
        return label
    }()
    
    private let flowerLanguageLabel: UILabel = {
        let label = UILabel()
        label.text = "#유희 #단아함 #겸손한 사랑"
        label.textColor = UIColor.gray06
        label.font = .Pretendard(size: 14, family: .Medium)
        return label
    }()
    
    private let todaysFlowerButton: CustomButton = {
        let button = CustomButton(buttonType: .todaysFlower)
        return button
    }()
    
    private lazy var textVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            todaysFlowerLabel,
            flowerOneLineDescriptionLabel,
            flowerNameLabel,
            flowerLanguageLabel,
            todaysFlowerButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.setCustomSpacing(23, after: flowerLanguageLabel)
        return stackView
    }()
    
    private let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .defaultFlower
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textVStackView, flowerImageView])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        self.backgroundColor = UIColor.gray02
        self.layer.borderColor = UIColor.gray03.cgColor
        self.layer.borderWidth = 1
        
        [
            mainStackView
        ].forEach(addSubview(_:))
        setupAutoLayout()
    }
}

// MARK: - AutoLayout

extension TodaysFlowerViewCell2 {
    private func setupAutoLayout() {
        todaysFlowerButton.snp.makeConstraints {
            $0.height.equalTo(Metric.todaysFlowerButtonHeight)
            $0.width.equalTo(Metric.todaysFlowerButtonWidth)
        }
        
        flowerImageView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(Metric.flowerImageViewWidthMultiplier)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalToSuperview().offset(Metric.mainStackViewLeadingOffset)
        }
    }
}
