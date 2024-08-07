//
//  PurposeViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/5/24.
//

import UIKit
import SnapKit
import Combine

final class PurposeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: PurposeViewModel
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: CustomizingCoordinator?
    
    // MARK: - UI
    
    private lazy var headerView = CustomHeaderView(currentVC: self, coordinator: coordinator)
    private let purposeView = PurposeView()
    private lazy var bottomView = CustomBottomView(coordinator: coordinator)
    
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
        bind()
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
            purposeView,
            bottomView
        ].forEach(view.addSubview(_:))
        
        setupAutoLayout()
    }
    
    private func bind() {
        let input = PurposeViewModel.Input(PurposePublisher: purposeView.valuePublisher)
        let output = viewModel.transform(input: input)
        
        output.updateViewPublisher.sink { [unowned self] purpose in
            self.bottomView.config(bool: purpose != .none)
        }.store(in: &cancellables)
    }
}

// MARK: - AutoLayout

extension PurposeViewController {
    private func setupAutoLayout() {
        let sideMargin: CGFloat = 21
        let verticalSpacing: CGFloat = 32
        let bottomOffset: CGFloat = -45.adjustedH(basedOnHeight: 852)
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(sideMargin)
            $0.trailing.equalToSuperview().offset(-sideMargin)
        }
        
        purposeView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(verticalSpacing)
            $0.leading.equalToSuperview().offset(sideMargin)
            $0.trailing.equalToSuperview().offset(-sideMargin)
            $0.bottom.equalTo(bottomView.snp.top).offset(bottomOffset)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
