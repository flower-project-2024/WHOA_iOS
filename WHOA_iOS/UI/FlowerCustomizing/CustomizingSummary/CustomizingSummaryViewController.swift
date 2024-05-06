//
//  CustomSummaryViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 3/20/24.
//

import UIKit

class CustomizingSummaryViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: CustomizingSummaryViewModel
    
    // MARK: - UI
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let exitButton = ExitButton()
    private let progressHStackView = CustomProgressHStackView(numerator: 7, denominator: 7)
    private let titleLabel = CustomTitleLabel(text: "이렇게 요구서를 저장할까요?")
    
    private let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
        return view
    }()
    
    private lazy var customSummaryView: UIView = CustomSummaryView(model: viewModel.customizingSummaryModel)
    
    private let backButton: UIButton = {
        let button = BackButton(isActive: true)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = NextButton()
        button.isActive = true
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var navigationHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            backButton,
            nextButton
        ].forEach { stackView.addArrangedSubview($0) }
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 9
        return stackView
    }()
    

    // MARK: - Initialize
    
    init(viewModel: CustomizingSummaryViewModel) {
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
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(scrollContentView)
        
        scrollContentView.addSubview(exitButton)
        scrollContentView.addSubview(progressHStackView)
        scrollContentView.addSubview(titleLabel)
        
        scrollContentView.addSubview(contentView)
        contentView.addSubview(customSummaryView)
        
        scrollContentView.addSubview(navigationHStackView)
        
        setupAutoLayout()
    }
    
    @objc
    private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func nextButtonTapped() {
        let saveAlertVC = SaveAlertViewController(saveResult: .success)
        
        saveAlertVC.modalPresentationStyle = .fullScreen
        present(saveAlertVC, animated: true)
    }
}

extension CustomizingSummaryViewController {
    private func setupAutoLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(4)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        exitButton.snp.makeConstraints {
            $0.top.equalTo(scrollView).offset(17)
            $0.leading.equalToSuperview().offset(17)
        }
        
        progressHStackView.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).offset(29)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(12.75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressHStackView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(97)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(navigationHStackView.snp.top).offset(-42)
        }
        
        customSummaryView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(25)
            $0.leading.trailing.bottom.equalTo(contentView)
            $0.height.equalTo(1000)
        }
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(56)
        }
        
        navigationHStackView.snp.makeConstraints {
            $0.bottom.equalTo(scrollView)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-11.5)
        }
    }
}
