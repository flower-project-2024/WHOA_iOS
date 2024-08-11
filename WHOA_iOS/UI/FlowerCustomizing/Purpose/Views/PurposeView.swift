//
//  PurposeView.swift
//  WHOA_iOS
//
//  Created by KSH on 4/22/24.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

final class PurposeView: UIView {
    
    // MARK: - UI
    
    private lazy var affectionButton = buildPurposeButton(purpose: .affection)
    private lazy var birthdayButton = buildPurposeButton(purpose: .birthday)
    private lazy var gratitudeButton = buildPurposeButton(purpose: .gratitude)
    private lazy var proposeButton = buildPurposeButton(purpose: .propose)
    private lazy var partyButton = buildPurposeButton(purpose: .party)
    private lazy var employmentButton = buildPurposeButton(purpose: .employment)
    private lazy var promotionButton = buildPurposeButton(purpose: .promotion)
    private lazy var friendshipButton = buildPurposeButton(purpose: .friendship)
    
    private lazy var purposeButtonHStackView1 = buildPurposeButtonHStackView(
        button1: affectionButton,
        button2: birthdayButton
    )
    
    private lazy var purposeButtonHStackView2 = buildPurposeButtonHStackView(
        button1: gratitudeButton,
        button2: proposeButton
    )
    
    private lazy var purposeButtonHStackView3 = buildPurposeButtonHStackView(
        button1: partyButton,
        button2: employmentButton
    )
    
    private lazy var purposeButtonHStackView4 = buildPurposeButtonHStackView(
        button1: promotionButton,
        button2: friendshipButton
    )
    
    private lazy var purposeButtonVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            purposeButtonHStackView1,
            purposeButtonHStackView2,
            purposeButtonHStackView3,
            purposeButtonHStackView4
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(purposeButtonVStackView)
        
        setupAutoLayout()
    }
    
    func getSelectPurposePublisher() -> AnyPublisher<PurposeType, Never> {
        let buttonPublishers = [
            affectionButton.tapPublisher.map { PurposeType.affection },
            birthdayButton.tapPublisher.map { PurposeType.birthday },
            gratitudeButton.tapPublisher.map { PurposeType.gratitude },
            proposeButton.tapPublisher.map { PurposeType.propose },
            partyButton.tapPublisher.map { PurposeType.party },
            employmentButton.tapPublisher.map { PurposeType.employment },
            promotionButton.tapPublisher.map { PurposeType.promotion },
            friendshipButton.tapPublisher.map { PurposeType.friendship }
        ]
        
        return Publishers.MergeMany(buttonPublishers)
            .eraseToAnyPublisher()
    }
    
    func updateSelectedButton(for purpose: PurposeType) {
        resetView()
        var selectedButton: UIButton?
        
        switch purpose {
        case .affection:
            selectedButton = affectionButton
        case .birthday:
            selectedButton = birthdayButton
        case .gratitude:
            selectedButton = gratitudeButton
        case .propose:
            selectedButton = proposeButton
        case .party:
            selectedButton = partyButton
        case .employment:
            selectedButton = employmentButton
        case .promotion:
            selectedButton = promotionButton
        case .friendship:
            selectedButton = friendshipButton
        case .none:
            break
        }
        
        configureButton(
            button: selectedButton,
            backgroundColor: .second1.withAlphaComponent(0.2),
            font: .Pretendard(size: 16, family: .SemiBold),
            fontColor: .primary,
            borderColor: UIColor.secondary03.cgColor
        )
    }
    
    func resetView() {
        [
            affectionButton,
            birthdayButton,
            gratitudeButton,
            proposeButton,
            partyButton,
            employmentButton,
            promotionButton,
            friendshipButton
        ].forEach {
            configureButton(
                button: $0,
                backgroundColor: .gray02,
                font: .Pretendard(size: 16),
                fontColor: .gray08,
                borderColor: UIColor.clear.cgColor
            )
        }
    }
    
    private func configureButton(
        button: UIButton?,
        backgroundColor: UIColor,
        font: UIFont,
        fontColor: UIColor,
        borderColor: CGColor
    ) {
        var titleAttr = AttributedString(button?.configuration?.title ?? "")
        titleAttr.font = font
        button?.configuration?.attributedTitle = titleAttr
        button?.configuration?.baseForegroundColor = fontColor
        button?.configuration?.baseBackgroundColor = backgroundColor
        button?.layer.borderColor = borderColor
    }
    
    private func getPurposeImage(_ purposeType: PurposeType) -> UIImage? {
        switch purposeType {
        case .affection:
            return .affection
        case .birthday:
            return .birthday
        case .gratitude:
            return .gratitude
        case .propose:
            return .propose
        case .party:
            return .party
        case .employment:
            return .employment
        case .promotion:
            return .promotion
        case .friendship:
            return .friendship
        case .none:
            return nil
        }
    }
    
    private func buildPurposeButton(purpose: PurposeType) -> UIButton {
        let button = UIButton(type: .custom)
        
        var config = UIButton.Configuration.gray()
        config.baseBackgroundColor = .gray02
        config.baseForegroundColor = .gray08
        config.title = purpose.rawValue
        config.image = getPurposeImage(purpose)
        config.imagePlacement = .top
        config.imagePadding = 10
        config.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
        button.configuration = config
        
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        
        var titleAttr = AttributedString(purpose.rawValue)
        titleAttr.font = .Pretendard(size: 16)
        button.configuration?.attributedTitle = titleAttr
        return button
    }
    
    private func buildPurposeButtonHStackView(button1: UIButton, button2: UIButton) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [
            button1,
            button2
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 9
        return stackView
    }
}

// MARK: - AutoLayout

extension PurposeView {
    private func setupAutoLayout() {
        [
            affectionButton,
            gratitudeButton,
            partyButton,
            promotionButton,
        ].forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(94.adjustedH())
            }
        }
        
        purposeButtonVStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
