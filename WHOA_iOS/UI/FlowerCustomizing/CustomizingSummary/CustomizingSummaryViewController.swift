//
//  CustomSummaryViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 3/20/24.
//

import UIKit
import Combine

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
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: CustomizingCoordinator?
    
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        return tapGesture.publisher(for: \.state)
            .filter { $0 == .ended }
            .map { _ in }
            .eraseToAnyPublisher()
    }()
    
    // MARK: - UI
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerView = CustomHeaderView(
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
        setupUI()
        bind()
        observe()
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
    }
    
    private func bind() {
        let input = CustomizingSummaryViewModel.Input(
            textInput: requestDetailView.textInputPublisher,
            nextButtonTapped: bottomView.nextButtonTappedPublisher
        )
        let output = viewModel.transform(input: input)
        
        output.setupRequestDetailView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bouquetData in
                self?.requestDetailView.setupUI(bouquetData: bouquetData)
            }
            .store(in: &cancellables)
        
        output.setupRequestTitle
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.requestDetailView.setupRequestTitle(title: title)
            }
            .store(in: &cancellables)
        
        output.networkError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self, let error = error else { return }
                let saveResult: SaveResult = (error == .duplicateError ? .duplicateError : .networkError)
                coordinator?.showSaveAlert(from: self, saveResult: saveResult)
            }
            .store(in: &cancellables)
        
        output.showSaveAlertView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                coordinator?.showSaveAlert(from: self, saveResult: .success)
            }
            .store(in: &cancellables)
    }
    
    private func observe() {
        headerView.exitButtonTappedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.showExitAlertVC(from: self)
            }
            .store(in: &cancellables)
        
        viewTapPublisher
            .sink { [weak self] _ in
                self?.view.endEditing(true)
            }
            .store(in: &cancellables)
        
        bottomView.backButtonTappedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
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
}
