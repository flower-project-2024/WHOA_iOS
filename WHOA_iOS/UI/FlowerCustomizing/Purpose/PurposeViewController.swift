//
//  PurposeViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/5/24.
//

import UIKit
import SnapKit

class PurposeViewController: UIViewController {

    // MARK: - Properties
    
    private let viewModel: PurposeViewModel
    
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
        
        setupUI()
        setupButtonActions()
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(purposeView)
        
        setupAutoLayout()
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
        viewModel.updatePurposeTypeSelection(sender: sender, buttonText: sender.titleLabel?.text, setPurposeType: viewModel.setPurposeType)
        viewModel.updateNextButtonState(purposeButtons: purposeButtons, nextButton: purposeView.nextButton)
    }
    
    @objc
    func nextButtonTapped() {
        viewModel.goToNextVC(fromCurrentVC: self, animated: true)
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
