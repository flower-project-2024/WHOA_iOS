//
//  PurposeViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/5/24.
//

import UIKit
import SnapKit

class PurposeViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: PurposeViewModel
    
    // MARK: - UI
    
    private let exitButton = ExitButton()
    private let progressHStackView = CustomProgressHStackView(numerator: 1, denominator: 7)
    private let titleLabel = CustomTitleLabel(text: "꽃다발 구매 목적")
    private let descriptionLabel = CustomDescriptionLabel(text: "선택한 목적에 맞는 꽃말을 가진 꽃들을 추천해드릴게요", numberOfLines: 2)
    
    private let affectionButton = PurposeButton(purposeType: PurposeType.affection)
    private let birthdayButton = PurposeButton(purposeType: PurposeType.birthday)
    private let gratitudeButton = PurposeButton(purposeType: PurposeType.gratitude)
    private let proposeButton = PurposeButton(purposeType: PurposeType.propose)
    private let partyButton = PurposeButton(purposeType: PurposeType.party)
    private let employmentButton = PurposeButton(purposeType: PurposeType.employment)
    private let promotionButton = PurposeButton(purposeType: PurposeType.promotion)
    private let friendshipButton = PurposeButton(purposeType: PurposeType.friendship)
    
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
    
    init(viewModel: PurposeViewModel) {
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
        view.addSubview(purposeButtonVStackView)
        view.addSubview(borderLine)
        view.addSubview(navigationHStackView)
        
        setupAutoLayout()
    }
    
    private func setupButtonActions() {
        let purposeButtons = [
            affectionButton, birthdayButton,
            gratitudeButton, proposeButton,
            partyButton, employmentButton,
            promotionButton, friendshipButton,
        ]
        
        purposeButtons.forEach { $0.addTarget(self, action: #selector(purposeButtonTapped), for: .touchUpInside) }
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc
    func purposeButtonTapped(sender: PurposeButton) {
        let purposeButtons = [
            affectionButton, birthdayButton,
            gratitudeButton, proposeButton,
            partyButton, employmentButton,
            promotionButton, friendshipButton,
        ]
        
        sender.isSelected.toggle()
        
        viewModel.updateButtonState(sender: sender, purposeButtons: purposeButtons)
        viewModel.updatePurposeTypeSelection(sender: sender, buttonText: sender.titleLabel?.text, setPurposeType: viewModel.setPurposeType)
        viewModel.updateNextButtonState(purposeButtons: purposeButtons, nextButton: nextButton)
    }
    
    @objc
    func nextButtonTapped() {
        viewModel.goToNextVC(fromCurrentVC: self, animated: true)
    }
}

// MARK: - AutoLayout

extension PurposeViewController {
    private func setupAutoLayout() {
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(17)
            $0.leading.equalToSuperview().offset(22)
        }
        
        progressHStackView.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).offset(29)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(19.5)
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
            $0.width.equalTo(256)
        }
        
        purposeButtonVStackView.snp.makeConstraints {
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            $0.leading.trailing.equalToSuperview().inset(18)
        }
    }
}
