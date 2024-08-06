//
//  PurposeView.swift
//  WHOA_iOS
//
//  Created by KSH on 4/22/24.
//

import UIKit
import SnapKit

final class PurposeView: UIView {
    
    private lazy var affectionButton = {
        let button = buildPurposeButton(purpose: .affection)
        return button
    }()
    
    private lazy var birthdayButton = {
        let button = buildPurposeButton(purpose: .birthday)
        return button
    }()
    
    private lazy var gratitudeButton = {
        let button = buildPurposeButton(purpose: .gratitude)
        return button
    }()
    
    private lazy var proposeButton = {
        let button = buildPurposeButton(purpose: .propose)
        return button
    }()
    
    private lazy var partyButton = {
        let button = buildPurposeButton(purpose: .party)
        return button
    }()
    
    private lazy var employmentButton = {
        let button = buildPurposeButton(purpose: .employment)
        return button
    }()
    
    private lazy var promotionButton = {
        let button = buildPurposeButton(purpose: .promotion)
        return button
    }()
    
    private lazy var friendshipButton = {
        let button = buildPurposeButton(purpose: .friendship)
        return button
    }()
    
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
    
    private func buildPurposeButton(purpose: PurposeType) -> UIButton {
        let button = UIButton(type: .custom)
        
        var config = UIButton.Configuration.gray()
        config.baseBackgroundColor = .gray02
        config.title = purpose.rawValue
        config.image = getPurposeImage(purpose)
        config.imagePlacement = .top
        config.imagePadding = 10
        config.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
        
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.configuration = config
        
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = .gray02
        button.configuration?.baseForegroundColor = .gray08
        var titleAttr = AttributedString(purpose.rawValue)
        titleAttr.font = .Pretendard(size: 16)
        button.configuration?.attributedTitle = titleAttr
        return button
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
