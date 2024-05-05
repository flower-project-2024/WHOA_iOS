//
//  PurposeViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/5/24.
//

import UIKit
import Combine
import SnapKit

class PurposeViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: PurposeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI
    
    private let purposeView: PurposeView = PurposeView()
    
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
        
        bind()
        setupUI()
        setupButtonActions()
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(purposeView)
        
        setupAutoLayout()
    }
    
    private func bind() {
        viewModel.$nextButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                self?.purposeView.nextButton.isActive = enabled
            }
            .store(in: &cancellables)
    }
    
    private func setupButtonActions() {
        let purposeButtons = [
            purposeView.affectionButton, purposeView.birthdayButton,
            purposeView.gratitudeButton, purposeView.proposeButton,
            purposeView.partyButton, purposeView.employmentButton,
            purposeView.promotionButton, purposeView.friendshipButton,
        ]
        
        purposeButtons.forEach { $0.addTarget(self, action: #selector(purposeButtonTapped), for: .touchUpInside) }
        purposeView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc
    func purposeButtonTapped(sender: PurposeButton) {
        let purposeButtons = [
            purposeView.affectionButton, purposeView.birthdayButton,
            purposeView.gratitudeButton, purposeView.proposeButton,
            purposeView.partyButton, purposeView.employmentButton,
            purposeView.promotionButton, purposeView.friendshipButton,
        ]
        
        sender.isSelected.toggle()
        
        viewModel.updateButtonState(sender: sender, purposeButtons: purposeButtons)
        viewModel.setPurposeType(sender.purposeType)
    }
    
    @objc
    func nextButtonTapped() {
        guard let purposeType = viewModel.getPurposeType() else { return }
        
        let flowerColorPickerVC = FlowerColorPickerViewController(viewModel: FlowerColorPickerViewModel())
        
        flowerColorPickerVC.modalPresentationStyle = .fullScreen
        
        present(flowerColorPickerVC, animated: true)
    }
}

// MARK: - AutoLayout

extension PurposeViewController {
    private func setupAutoLayout() {
        purposeView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
