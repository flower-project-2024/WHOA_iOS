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
    weak var coordinator: CustomizingCoordinator?
    
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
    
    private lazy var exitButton = ExitButton(currentVC: self, coordinator: coordinator)
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
        
        bind()
        setupUI()
        setupTapGesture()
        requestDetailView.config(model: viewModel.customizingSummaryModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        extendedLayoutIncludesOpaqueBars = false
        navigationController?.setNavigationBarHidden(false, animated: false)
        tabBarController?.tabBar.isHidden = false
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
        
        requestDetailView.requestTitleTextField.delegate = self
        scrollView.delegate = self
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func bind() {
        viewModel.$bouquetId
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bouquetId in
                self?.handleBouquetId(bouquetId)
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$imageUploadSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                guard success else { return }
                self?.presentSaveAlert(saveResult: .success)
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$networkError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let error = error else { return }
                let saveResult: SaveResult = (error == .duplicateError ? .duplicateError : .networkError)
                self?.presentSaveAlert(saveResult: saveResult)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func presentSaveAlert(saveResult: SaveResult) {
        let saveAlertVC = SaveAlertViewController(currentVC: self, saveResult: saveResult)
        saveAlertVC.modalPresentationStyle = .fullScreen
        self.present(saveAlertVC, animated: true)
    }
    
    private func handleBouquetId(_ bouquetId: Int?) {
        guard
            let bouquetId = bouquetId,
            let id = viewModel.memberId
        else { return }
        
        if let imageFiles = viewModel.customizingSummaryModel.requirement?.imageFiles, !imageFiles.isEmpty {
            viewModel.submitRequirementImages(id: id, bouquetId: bouquetId, imageFiles: imageFiles)
        } else {
            presentSaveAlert(saveResult: .success)
        }
    }
    
    // MARK: - Actions
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func nextButtonTapped() {
        guard let id = viewModel.memberId else { return }
        let dto = CustomizingSummaryModel.convertModelToCustomBouquetRequestDTO(requestName: viewModel.requestTitle, viewModel.customizingSummaryModel)
        
        viewModel.saveBouquet(id: id, DTO: dto)
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        requestDetailView.requestTitleTextFieldPlaceholder.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            requestDetailView.requestTitleTextFieldPlaceholder.isHidden = false
            viewModel.getRequestTitle(title: requestDetailView.requestTitleTextFieldPlaceholder.text)
        } else {
            viewModel.getRequestTitle(title: textField.text)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension CustomizingSummaryViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}
