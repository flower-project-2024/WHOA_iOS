//
//  FlowerReplacementViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/29/24.
//

import UIKit

final class AlternativesViewController: UIViewController {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let alternativesViewTopOffset = 60.0
        static let sideMargin = 20.0
    }
    
    // MARK: - Properties
    
    let viewModel: AlternativesViewModel
    weak var coordinator: CustomizingCoordinator?
    
    // MARK: - UI
    
    let alternativesView = AlternativesView()
    
    // MARK: - Initialize
    
    init(viewModel: AlternativesViewModel) {
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
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [
            alternativesView
        ].forEach(view.addSubview(_:))
        setupAutoLayout()
    }
    
    func bind() {
//        viewModel.$selectedButtonType
//            .receive(on: RunLoop.main)
//            .sink { [weak self] selectedType in
//                guard let self = self else { return }
//                self.colorOrientedButton.isSelected = selectedType == .colorOriented
//                self.hashTagOrientedButton.isSelected = selectedType == .hashTagOriented
//                
//                self.colorOrientedButton.configuration = self.colorOrientedButton.configure(isSelected: self.colorOrientedButton.isSelected)
//                self.hashTagOrientedButton.configuration = self.hashTagOrientedButton.configure(isSelected: self.hashTagOrientedButton.isSelected)
//            }
//            .store(in: &viewModel.cancellables)
//        
//        viewModel.$alternativesModel
//            .receive(on: RunLoop.main)
//            .map { alternatives in
//                guard let alternative = alternatives?.AlternativesType else { return false }
//                return alternative != .none
//            }
//            .assign(to: \.isActive, on: nextButton)
//            .store(in: &viewModel.cancellables)
    }
    
    // MARK: - Actions
    
//    @objc
//    private func spacebarButtonTapped(_ sender: UIButton) {
//        switch sender.tag {
//        case Attributes.colorOrientedButtonTag:
//            viewModel.getAlternatives(alternatives: .colorOriented)
//        case Attributes.hashTagOrientedButtonTag:
//            viewModel.getAlternatives(alternatives: .hashTagOriented)
//        default:
//            print("Unknown button tapped")
//        }
//    }
//    
//    @objc
//    func nextButtonTapped() {
//        guard let alternative = viewModel.alternativesModel?.AlternativesType else { return }
//        viewModel.dataManager.setAlternative(alternative)
//        coordinator?.showPackagingSelectionVC(from: self)
//    }
    
}

// MARK: - AutoLayout

extension AlternativesViewController {
    private func setupAutoLayout() {
        alternativesView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Metric.alternativesViewTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
        }
    }
}
