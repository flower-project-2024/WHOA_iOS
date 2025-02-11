//
//  TodaysFlowerViewCell2.swift
//  WHOA_iOS
//
//  Created by 김세훈 on 1/11/25.
//

import UIKit
import Combine

final class TodaysFlowerViewCell2: UICollectionViewCell {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let todaysFlowerButtonHeight: CGFloat = 32
        static let todaysFlowerButtonWidth: CGFloat = 193.0
        static let flowerImageViewWidthMultiplier: CGFloat = 0.675
        static let mainStackViewLeadingOffset: CGFloat = 24
    }
    
    /// Attributes
    private enum Attributes {
        static let todaysFlowerLabelText: String = "오늘의 추천 꽃"
    }
    
    // MARK: - Properties
    
    private let buttonTapSubject = PassthroughSubject<Void, Never>()
    var cancellables = Set<AnyCancellable>()
    
    var buttonTapPublisher: AnyPublisher<Void, Never> {
        buttonTapSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UI
    
    private let todaysFlowerLabel: UILabel = {
        let label = UILabel()
        label.text = Attributes.todaysFlowerLabelText
        label.font = .Pretendard(size: 14, family: .Medium)
        label.textColor = UIColor.gray07
        return label
    }()
    
    private let flowerOneLineDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(size: 18, family: .Bold)
        label.textColor = UIColor.customPrimary
        return label
    }()
    
    private let flowerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.secondary04
        label.font = .Pretendard(size: 24, family: .Bold)
        return label
    }()
    
    private let flowerLanguageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray06
        label.font = .Pretendard(size: 14, family: .Medium)
        return label
    }()
    
    private lazy var todaysFlowerButton: CustomButton = {
        let button = CustomButton(buttonType: .todaysFlower)
        button.addAction(UIAction { [weak self] _ in
            self?.buttonTapSubject.send()
        }, for: .touchUpInside)
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
        stackView.spacing = 9
        stackView.alignment = .leading
        stackView.setCustomSpacing(3, after: flowerOneLineDescriptionLabel)
        stackView.setCustomSpacing(23, after: flowerLanguageLabel)
        return stackView
    }()
    
    private let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textVStackView, flowerImageView])
        stackView.axis = .horizontal
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
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
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
    
    func configure(with data: TodaysFlowerModel) {
        let description = data.flowerOneLineDescription?.components(separatedBy: ",").first ?? ""
        let flowerLanguage = data.flowerExpressions?.first?.flowerLanguage
        
        flowerNameLabel.text = data.flowerName
        flowerOneLineDescriptionLabel.text = description
        flowerLanguageLabel.text = convertToHashtagString(
            flowerLanguage: flowerLanguage,
            for: flowerLanguageLabel
        )
        
        if let image = data.flowerImage {
            ImageProvider.shared.setImage(into: flowerImageView, from: image)
        }
    }
    
    private func convertToHashtagString(flowerLanguage: String?, for label: UILabel) -> String? {
        guard let flowerLanguage = flowerLanguage else { return nil }
        
        let keywords = flowerLanguage.components(separatedBy: ",")
            .map { "#\($0)" }
        
        var result = ""
        var currentWidth: CGFloat = 0
        let maxWidth = textVStackView.bounds.width
        
        for keyword in keywords {
            let keywordWidth = keyword.size(withAttributes: [.font: label.font ?? UIFont.systemFont(ofSize: 14)]).width
            
            if currentWidth + keywordWidth > maxWidth {
                break
            }
            
            result += (result.isEmpty ? "" : " ") + keyword
            currentWidth += keywordWidth + " ".size(withAttributes: [.font: label.font ?? UIFont.systemFont(ofSize: 14)]).width
        }
        
        return result
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
            $0.width.equalTo(self.snp.height).multipliedBy(Metric.flowerImageViewWidthMultiplier)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalToSuperview().offset(Metric.mainStackViewLeadingOffset)
        }
    }
}
