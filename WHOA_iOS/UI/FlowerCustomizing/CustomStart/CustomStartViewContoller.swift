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
            .sink(receiveValue: { [weak self] title in
                guard let self = self else { return }
                
                if title.isEmpty {
                    self.customStartView.updateButtonState(isEnabled: false)
                }else {
                    self.customStartView.updateButtonState(isEnabled: true)
                }
            })
            .store(in: &cancellables)
        
        output.showPurpose
            .sink { [weak self] title in
                self?.coordinator?.showPurposeVC(requestTitle: title)
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
