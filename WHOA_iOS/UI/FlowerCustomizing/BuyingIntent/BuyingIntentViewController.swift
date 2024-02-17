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
    private let descriptionLabel = CustomDescriptionLabel(text: "목적에 맞는 꽃말을 가진 꽃들을 추천해드릴게요", numberOfLines: 2)
    
    private let celebrationButton = BuyingIntentButton(text: BuyingIntentType.회갑.rawValue)
    private let birthdayButton = BuyingIntentButton(text: BuyingIntentType.생일.rawValue)
    private let condolenceButton = BuyingIntentButton(text: BuyingIntentType.추모.rawValue)
    private let weddingButton = BuyingIntentButton(text: BuyingIntentType.결혼식.rawValue)
    private let affectionButton = BuyingIntentButton(text: BuyingIntentType.애정표현.rawValue)
    private let promotionButton = BuyingIntentButton(text: BuyingIntentType.승진.rawValue)
    private let exhibitionButton = BuyingIntentButton(text: BuyingIntentType.전시.rawValue)
    private let awardButton = BuyingIntentButton(text: BuyingIntentType.수상.rawValue)
    private let apologyButton = BuyingIntentButton(text: BuyingIntentType.사과.rawValue)
    private let eventButton = BuyingIntentButton(text: BuyingIntentType.행사.rawValue)
    
    private lazy var intentButtonHStackView1 = BuyingIntentButtonHStackView(
        button1: celebrationButton,
        button2: birthdayButton
    )
    private lazy var intentButtonHStackView2 = BuyingIntentButtonHStackView(
        button1: condolenceButton,
        button2: weddingButton
    )
    private lazy var intentButtonHStackView3 = BuyingIntentButtonHStackView(
        button1: affectionButton,
        button2: promotionButton
    )
    private lazy var intentButtonHStackView4 = BuyingIntentButtonHStackView(
        button1: exhibitionButton,
        button2: awardButton
    )
    private lazy var intentButtonHStackView5 = BuyingIntentButtonHStackView(
        button1: apologyButton,
        button2: eventButton
    )
    
    private lazy var intentButtonVStackView: UIStackView = {
        let stackView = UIStackView()
        [
            intentButtonHStackView1,
            intentButtonHStackView2,
            intentButtonHStackView3,
            intentButtonHStackView4,
            intentButtonHStackView5
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 9
        return stackView
    }()
    
    private let backButton = BackButton()
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
        view.addSubview(navigationHStackView)
        
        setupAutoLayout()
    }
    
    private func setupButtonActions() {
        celebrationButton.addTarget(self, action: #selector(intentButtonTapped), for: .touchUpInside)
        birthdayButton.addTarget(self, action: #selector(intentButtonTapped), for: .touchUpInside)
        condolenceButton.addTarget(self, action: #selector(intentButtonTapped), for: .touchUpInside)
        weddingButton.addTarget(self, action: #selector(intentButtonTapped), for: .touchUpInside)
        affectionButton.addTarget(self, action: #selector(intentButtonTapped), for: .touchUpInside)
        promotionButton.addTarget(self, action: #selector(intentButtonTapped), for: .touchUpInside)
        exhibitionButton.addTarget(self, action: #selector(intentButtonTapped), for: .touchUpInside)
        awardButton.addTarget(self, action: #selector(intentButtonTapped), for: .touchUpInside)
        apologyButton.addTarget(self, action: #selector(intentButtonTapped), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(intentButtonTapped), for: .touchUpInside)
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc
    func intentButtonTapped(sender: BuyingIntentButton) {
        let intentButtons = [
            celebrationButton, birthdayButton,
            condolenceButton, weddingButton,
            affectionButton, promotionButton,
            exhibitionButton, awardButton,
            apologyButton, eventButton
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
            $0.top.equalTo(descriptionLabel.snp_bottomMargin).offset(27)
            $0.leading.equalToSuperview().offset(15.75)
            $0.trailing.equalToSuperview().offset(-15.75)
            
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
