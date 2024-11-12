//
//  FlowerReplacementViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/29/24.
//

import UIKit
import Combine

final class AlternativesViewController: UIViewController {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let alternativesViewTopOffset = 60.0
        static let sideMargin = 20.0
    }
    
    // MARK: - Properties
    
    private let viewModel: AlternativesViewModel
    private var cancellables = Set<AnyCancellable>()
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
        let input = AlternativesViewModel.Input(
            alternativeSelected: alternativesView.valuePublisher,
            nextButtonTapped: alternativesView.nextButtonTappedPublisher
        )
        let output = viewModel.transform(input: input)
        
        output.setupAlternative
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alternative in
                self?.alternativesView.updateButtonSelection(for: alternative)
            }
            .store(in: &cancellables)
        
        output.showPackagingSelectionView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.showPackagingSelectionVC(from: self)
            }
            .store(in: &cancellables)
    }
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
