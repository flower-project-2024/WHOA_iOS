//
//  PackagingSelectionViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 3/9/24.
//

import UIKit
import Combine

final class PackagingSelectionViewController: UIViewController {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let sideMargin = 20.0
        static let packagingSelectionViewTopOffset = 32.0
        static let requirementTextViewTopOffset = 16.0
        static let requirementTextViewHeightMultiplier = 0.34
    }
    
    /// Attributes
    private enum Attributes {
        static let headerViewTitle = "원하는 포장지 종류가 있나요?"
    }
    
    // MARK: - Properties
    
    let viewModel: PackagingSelectionViewModel
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
    
    private lazy var headerView = CustomHeaderView(
        currentVC: self,
        coordinator: coordinator,
        numerator: 4,
        title: Attributes.headerViewTitle
    )
    private let packagingSelectionView = PackagingSelectionView()
    private let requirementTextView = RequirementTextView()
    private let bottomView = CustomBottomView(backButtonState: .enabled, nextButtonEnabled: false)
    
    // MARK: - Initialize
    
    init(viewModel: PackagingSelectionViewModel) {
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
        
        [
            headerView,
            packagingSelectionView,
            requirementTextView,
            bottomView
        ].forEach(view.addSubview(_:))
        setupAutoLayout()
    }
    
    private func bind() {
        let input = PackagingSelectionViewModel.Input(
            packagingAssignSelected: packagingSelectionView.valuePublisher,
            textInput: requirementTextView.textInputPublisher,
            nextButtonTapped: bottomView.nextButtonTappedPublisher
        )
        let output = viewModel.transform(input: input)
        
        output.setupPackagingAssign
            .receive(on: DispatchQueue.main)
            .sink { [weak self] packagingAssign in
                self?.packagingSelectionView.updateButtonSelection(for: packagingAssign)
                self?.requirementTextView.setTextViewHidden(packagingAssign != .myselfAssign)
            }
            .store(in: &cancellables)
        
        output.setupAssignText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.requirementTextView.setText(text)
            }
            .store(in: &cancellables)
        
        output.nextButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.bottomView.configNextButton(isEnabled)
            }
            .store(in: &cancellables)
        
        output.showFlowerPriceView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.showFlowerPriceVC()
            }
            .store(in: &cancellables)
    }
    
    private func observe() {
        viewTapPublisher
            .sink { [weak self] _ in
                self?.view.endEditing(true)
            }
            .store(in: &cancellables)
        
        bottomView.backButtonTappedPublisher
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - AutoLayout

extension PackagingSelectionViewController {
    private func setupAutoLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
        }
        
        packagingSelectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(Metric.packagingSelectionViewTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
        }
        
        requirementTextView.snp.makeConstraints {
            $0.top.equalTo(packagingSelectionView.snp.bottom).offset(Metric.requirementTextViewTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
            $0.height.equalTo(self.requirementTextView.snp.width).multipliedBy(Metric.requirementTextViewHeightMultiplier)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
