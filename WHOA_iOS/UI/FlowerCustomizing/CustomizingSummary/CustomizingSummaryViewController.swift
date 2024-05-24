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
    
    private let requestDetailView = RequestDetailView(requestDetailType: .custom)
    
    private let borderLine = ShadowBorderLine()
    
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
        setupTapGesture()
        requestDetailView.config(model: viewModel.customizingSummaryModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(scrollContentView)
        
        scrollContentView.addSubview(exitButton)
        scrollContentView.addSubview(progressHStackView)
        scrollContentView.addSubview(titleLabel)
        
        scrollContentView.addSubview(requestDetailView)
        
        scrollContentView.addSubview(borderLine)
        scrollContentView.addSubview(navigationHStackView)
        
        setupAutoLayout()
        
        requestDetailView.requestNameTextField.delegate = self
        scrollView.delegate = self
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        requestDetailView.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func dismissKeyboard() {
        requestDetailView.requestNameTextField.isEnabled = false
        requestDetailView.requestNameTextFieldPlaceholder.isHidden = requestDetailView.requestNameTextField.text == "" ? false : true
        view.endEditing(true)
    }
    
    @objc
    private func editButtonTapped() {
        requestDetailView.requestNameTextField.isEnabled = true
        requestDetailView.requestNameTextFieldPlaceholder.isHidden = true
        requestDetailView.requestNameTextField.becomeFirstResponder()
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
        }
        
        requestDetailView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(navigationHStackView.snp.top).offset(-42)
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
            $0.bottom.equalTo(scrollView)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-11.5)
        }
    }
}

// MARK: - UITextFieldDelegate

extension CustomizingSummaryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        requestDetailView.requestNameTextField.isEnabled = false
        requestDetailView.requestNameTextFieldPlaceholder.isHidden = textField.text == "" ? false : true
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            viewModel.requestName = text
        }
    }
}

extension CustomizingSummaryViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}
