//
//  CustomStartViewContoller.swift
//  WHOA_iOS
//
//  Created by KSH on 8/15/24.
//

import UIKit
import Combine

final class CustomStartViewContoller: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: CustomStartViewModel
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
    
    private let headerView = CustomStartHeaderView()
    private let customStartView = CustomStartView()
    
    // MARK: - Initialize
    
    init(viewModel: CustomStartViewModel = CustomStartViewModel()) {
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
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [
            headerView,
            customStartView
        ].forEach(view.addSubview(_:))
        
        setupAutoLayout()
    }
    
    private func bind() {
        let input = CustomStartViewModel.Input(
            textInput: customStartView.textInputTappedPublisher,
            startButtonTapped: customStartView.startButtonTappedPublisher
        )
        let output = viewModel.transform(input: input)
        
        output.requestTitle
            .sink { [weak self] title in
                if title.isEmpty {
                    self?.customStartView.updateButtonState(isEnabled: false)
                } else {
                    self?.customStartView.updateButtonState(isEnabled: true)
                }
            }
            .store(in: &cancellables)
        
        output.showPurpose
            .sink { [weak self] _ in
                self?.coordinator?.showPurposeVC()
            }
            .store(in: &cancellables)
    }
    
    private func observe() {
        viewTapPublisher
            .sink { [weak self] _ in
                self?.view.endEditing(true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - AutoLayout

extension CustomStartViewContoller {
    private func setupAutoLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        customStartView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.height).multipliedBy(0.18)
        }
    }
}
