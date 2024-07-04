//
//  PurposeView.swift
//  WHOA_iOS
//
//  Created by KSH on 4/22/24.
//

import UIKit
import SnapKit

class PurposeView: UIView {
    
    // MARK: - Properties
    
    let currentVC: UIViewController
    let coordinator: CustomizingCoordinator?
    
    // MARK: - UI
    
    private lazy var exitButton = ExitButton(currentVC: currentVC, coordinator: coordinator)
    private let progressHStackView = CustomProgressHStackView(numerator: 1, denominator: 7)
    private let titleLabel = CustomTitleLabel(text: "꽃다발 구매 목적")
    private let descriptionLabel = CustomDescriptionLabel(text: "선택한 목적에 맞는 꽃말을 가진\n꽃들을 추천해드릴게요", numberOfLines: 2)
    
    let affectionButton = PurposeButton(purposeType: .affection)
    let birthdayButton = PurposeButton(purposeType: .birthday)
    let gratitudeButton = PurposeButton(purposeType: .gratitude)
    let proposeButton = PurposeButton(purposeType: .propose)
    let partyButton = PurposeButton(purposeType: .party)
    let employmentButton = PurposeButton(purposeType: .employment)
    let promotionButton = PurposeButton(purposeType: .promotion)
    let friendshipButton = PurposeButton(purposeType: .friendship)
    
    private lazy var purposeButtonHStackView1 = PurposeButtonHStackView(
        button1: affectionButton,
        button2: birthdayButton
    )
    private lazy var purposeButtonHStackView2 = PurposeButtonHStackView(
        button1: gratitudeButton,
        button2: proposeButton
    )
    private lazy var purposeButtonHStackView3 = PurposeButtonHStackView(
        button1: partyButton,
        button2: employmentButton
    )
    private lazy var purposeButtonHStackView4 = PurposeButtonHStackView(
        button1: promotionButton,
        button2: friendshipButton
    )
    
    private lazy var purposeButtonVStackView: UIStackView = {
        let stackView = UIStackView()
        [
            purposeButtonHStackView1,
            purposeButtonHStackView2,
            purposeButtonHStackView3,
            purposeButtonHStackView4
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private let borderLine = ShadowBorderLine()
    
    let backButton = BackButton(isActive: false)
    let nextButton = NextButton()
    
    private lazy var navigationHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            backButton,
            nextButton
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 9
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    init(currentVC: UIViewController, coordinator: CustomizingCoordinator?) {
        self.currentVC = currentVC
        self.coordinator = coordinator
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(exitButton)
        addSubview(progressHStackView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(purposeButtonVStackView)
        addSubview(borderLine)
        addSubview(navigationHStackView)
        
        setupAutoLayout()
    }
}

extension PurposeView {
    private func setupAutoLayout() {
        exitButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.equalToSuperview().offset(22)
        }
        
        progressHStackView.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).offset(29)
            $0.leading.trailing.equalToSuperview().inset(19.5)
            $0.height.equalTo(12.75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressHStackView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(114)
        }
        
        purposeButtonVStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-21)
            $0.height.lessThanOrEqualToSuperview().multipliedBy(0.5)
        }
        
        borderLine.snp.makeConstraints {
            $0.top.equalTo(navigationHStackView.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(56)
        }
        
        navigationHStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-8)
            $0.leading.trailing.equalToSuperview().inset(18)
        }
    }
}
