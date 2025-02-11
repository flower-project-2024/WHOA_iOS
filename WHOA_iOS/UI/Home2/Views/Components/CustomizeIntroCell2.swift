//
//  CustomizeIntroCell2.swift
//  WHOA_iOS
//
//  Created by 김세훈 on 1/12/25.
//

import UIKit
import Combine

final class CustomizeIntroCell2: UICollectionViewCell {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let customizeButtonHeight: CGFloat = 32.0
        static let customizeButtonWidth: CGFloat = 194.0
        static let customizeButtonWidthMultiplier: CGFloat = 0.9
        static let stackViewInset: CGFloat = 26.0
    }
    
    /// Attributes
    private enum Attributes {
        static let customizeLabelText: String = "커스터마이징 탭"
        static let bouqetWithWhoaLabelText: String = "WHOA로 만드는\n나만의 꽃다발"
        static let descriptionLabelText: String = "꽃말을 담아 내 마음을 전해보세요"
    }
    
    // MARK: - Properties
    
    private let buttonTapSubject = PassthroughSubject<Void, Never>()
    var cancellables = Set<AnyCancellable>()
    
    var buttonTapPublisher: AnyPublisher<Void, Never> {
        buttonTapSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UI
    
    private let customizeLabel: UILabel = {
        let label = UILabel()
        label.text = Attributes.customizeLabelText
        label.font = .Pretendard(family: .Bold)
        label.textColor = UIColor.secondary03
        return label
    }()
    
    private let bouqetWithWhoaLabel: UILabel = {
        let label = UILabel()
        label.text = Attributes.bouqetWithWhoaLabelText
        label.font = .Pretendard(size: 24, family: .Bold)
        label.textColor = UIColor.gray01
        label.numberOfLines = 2
        label.setLineHeight(lineHeight: 140)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Attributes.descriptionLabelText
        label.font = .Pretendard(family: .Medium)
        label.textColor = UIColor.gray06
        return label
    }()
    
    private lazy var customizeButton: CustomButton = {
        let button = CustomButton(buttonType: .customizing)
        button.addAction(UIAction { [weak self] _ in
            self?.buttonTapSubject.send()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var textVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            customizeLabel,
            bouqetWithWhoaLabel,
            descriptionLabel,
            customizeButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.setCustomSpacing(23, after: descriptionLabel)
        return stackView
    }()
    
    private let flowerDecoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.homeIllust
        return imageView
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
        self.backgroundColor = UIColor.gray09
        self.layer.borderColor = UIColor.customPrimary.cgColor
        self.layer.borderWidth = 1
        
        [
         textVStackView,
         flowerDecoImageView
        ].forEach(addSubview(_:))
        setupAutoLayout()
    }
}

// MARK: - AutoLayout

extension CustomizeIntroCell2 {
    private func setupAutoLayout() {
        customizeButton.snp.makeConstraints {
            $0.height.equalTo(Metric.customizeButtonHeight)
            $0.width.equalTo(Metric.customizeButtonWidth)
        }
        
        flowerDecoImageView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
        }
        
        textVStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(Metric.stackViewInset)
        }
    }
}
