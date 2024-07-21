//
//  PurposeViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/5/24.
//

import UIKit
import SnapKit

final class PurposeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: PurposeViewModel
    
    weak var coordinator: CustomizingCoordinator?
    
    // MARK: - UI
    
    private lazy var purposeView: PurposeView = PurposeView(currentVC: self, coordinator: coordinator)
    
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
        
        view.addSubview(purposeView)
        
        setupAutoLayout()
    }
    
    private func bind() {
        viewModel.$purposeModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self = self else { return }
                self.purposeView.nextButton.isActive = self.viewModel.updateNextButtonState()
            }
            .store(in: &viewModel.cancellables)
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
        guard let purpose = viewModel.getPurposeType() else { return }
        coordinator?.showColorPickerVC(purposeType: purpose)
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
