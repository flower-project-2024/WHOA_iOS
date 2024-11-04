//
//  CustomSummaryViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 3/20/24.
//

import UIKit

final class CustomizingSummaryViewController: UIViewController {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let sideMargin = 20.0
        static let requestDetailViewTopOffset = 37.0
        static let bottomViewTopOffset = 22.0
    }
    
    /// Attributes
    private enum Attributes {
        static let headerViewTitle = "이렇게 요구서를 저장할까요?"
    }
    
    // MARK: - Properties
    
    let viewModel: CustomizingSummaryViewModel
    weak var coordinator: CustomizingCoordinator?
    
    // MARK: - UI
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private lazy var headerView = CustomHeaderView(
        currentVC: self,
        coordinator: coordinator,
        numerator: 7,
        title: Attributes.headerViewTitle
    )
    private let requestDetailView = RequestDetailView(requestDetailType: .custom)
    private let bottomView = CustomBottomView(backButtonState: .enabled, nextButtonEnabled: true)
    
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
        requestDetailView.configureRequestTitle(title: viewModel.requestTitle)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBar(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configNavigationBar(isHidden: false)
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [
            headerView,
            requestDetailView,
            bottomView
        ].forEach(contentView.addSubview(_:))
        setupAutoLayout()
        requestDetailView.requestTitleTextField.delegate = self
        scrollView.delegate = self
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func bind() {
        viewModel.$imageUploadSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                guard let self = self,
                    success
                else { return }
                self.coordinator?.showSaveAlert(from: self, saveResult: .success)
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$networkError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self,
                      let error = error
                else { return }
                let saveResult: SaveResult = (error == .duplicateError ? .duplicateError : .networkError)
                self.coordinator?.showSaveAlert(from: self, saveResult: saveResult)
            }
            .store(in: &viewModel.cancellables)
    }
    
    // MARK: - Actions
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
//    @objc
//    private func backButtonTapped() {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @objc
//    private func nextButtonTapped() {
//        guard let id = viewModel.memberId else { return }
//        let dto = CustomizingSummaryModel.convertModelToCustomBouquetRequestDTO(requestName: viewModel.requestTitle, viewModel.customizingSummaryModel)
//        
//        viewModel.saveBouquet(id: id, DTO: dto, imageFiles: viewModel.customizingSummaryModel.requirement?.imageFiles)
//    }
}

extension CustomizingSummaryViewController {
    private func setupAutoLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
        }
        
        requestDetailView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(Metric.requestDetailViewTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
        }
        
        bottomView.snp.makeConstraints {
            $0.top.equalTo(requestDetailView.snp.bottom).offset(Metric.bottomViewTopOffset)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(scrollView.snp.bottom)
        }
    }
}

// MARK: - UITextFieldDelegate

extension CustomizingSummaryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            viewModel.getRequestTitle(title: requestDetailView.requestTitleTextField.placeholder)
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
