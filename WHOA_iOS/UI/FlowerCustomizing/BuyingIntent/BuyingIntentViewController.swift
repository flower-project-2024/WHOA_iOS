//
//  BuyingIntentViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/5/24.
//

import UIKit
import SnapKit

class BuyingIntentViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: BuyingIntentViewModel
    
    // MARK: - UI
    
    private let exitButton = ExitButton()
    private let progressHStackView = CustomProgressHStackView(numerator: 1, denominator: 7)
    private let titleLabel = CustomTitleLabel(text: "꽃다발 구매 목적")
    private let descriptionLabel = CustomDescriptionLabel(text: "선택한 목적에 맞는 꽃말을 가진 꽃들을 추천해드릴게요", numberOfLines: 2)
    
    private let affectionButton = BuyingIntentButton(purposeType: BuyingIntentType.affection)
    private let birthdayButton = BuyingIntentButton(purposeType: BuyingIntentType.birthday)
    private let gratitudeButton = BuyingIntentButton(purposeType: BuyingIntentType.gratitude)
    private let proposeButton = BuyingIntentButton(purposeType: BuyingIntentType.propose)
    private let partyButton = BuyingIntentButton(purposeType: BuyingIntentType.party)
    private let employmentButton = BuyingIntentButton(purposeType: BuyingIntentType.employment)
    private let promotionButton = BuyingIntentButton(purposeType: BuyingIntentType.promotion)
    private let friendshipButton = BuyingIntentButton(purposeType: BuyingIntentType.friendship)
    
    private lazy var intentButtonHStackView1 = BuyingIntentButtonHStackView(
        button1: affectionButton,
        button2: birthdayButton
    )
    private lazy var intentButtonHStackView2 = BuyingIntentButtonHStackView(
        button1: gratitudeButton,
        button2: proposeButton
    )
    private lazy var intentButtonHStackView3 = BuyingIntentButtonHStackView(
        button1: partyButton,
        button2: employmentButton
    )
    private lazy var intentButtonHStackView4 = BuyingIntentButtonHStackView(
        button1: promotionButton,
        button2: friendshipButton
    )
    
    private lazy var intentButtonVStackView: UIStackView = {
        let stackView = UIStackView()
        [
            intentButtonHStackView1,
            intentButtonHStackView2,
            intentButtonHStackView3,
            intentButtonHStackView4
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 9
        return stackView
    }()
    
    private let borderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    
    private let backButton = BackButton(isActive: false)
    private let nextButton = NextButton()
    
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
    
    // MARK: - Initialize
    
    init(viewModel: BuyingIntentViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupButtonActions()
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(exitButton)
        view.addSubview(progressHStackView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(intentButtonVStackView)
        view.addSubview(borderLine)
        view.addSubview(navigationHStackView)
        
        setupAutoLayout()
    }
    
    private func setupButtonActions() {
        let intentButtons = [
            affectionButton, birthdayButton,
            gratitudeButton, proposeButton,
            partyButton, employmentButton,
            promotionButton, friendshipButton,
        ]
        
        intentButtons.forEach { $0.addTarget(self, action: #selector(intentButtonTapped), for: .touchUpInside) }
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc
    func intentButtonTapped(sender: BuyingIntentButton) {
        let intentButtons = [
            affectionButton, birthdayButton,
            gratitudeButton, proposeButton,
            partyButton, employmentButton,
            promotionButton, friendshipButton,
        ]
        
        sender.isSelected.toggle()
        
        viewModel.updateButtonState(sender: sender, intentButtons: intentButtons)
        viewModel.updateIntentTypeSelection(sender: sender, buttonText: sender.titleLabel?.text, setBuyingIntentType: viewModel.setBuyingIntentType)
        viewModel.updateNextButtonState(intentButtons: intentButtons, nextButton: nextButton)
    }
    
    @objc
    func nextButtonTapped() {
        viewModel.goToNextVC(fromCurrentVC: self, animated: true)
    }
}

// MARK: - AutoLayout

extension BuyingIntentViewController {
    private func setupAutoLayout() {
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.leading.equalToSuperview().offset(17)
        }
        
        progressHStackView.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp_bottomMargin).offset(32)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(18.5)
            $0.height.equalTo(12.75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressHStackView.snp_bottomMargin).offset(24)
            $0.leading.equalTo(view).offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(114)
            $0.width.equalTo(256)
        }
        
        intentButtonVStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-21)
        }
        
        borderLine.snp.makeConstraints {
            $0.top.equalTo(navigationHStackView.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(3)
        }
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(56)
        }
        
        navigationHStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-11.5)
        }
    }
}
