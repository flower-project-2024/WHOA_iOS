//
//  CustomHeaderView.swift
//  WHOA_iOS
//
//  Created by KSH on 7/27/24.
//

import UIKit

final class CustomHeaderView: UIView {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let exitButtonTopOffset = 17.0
        static let progressViewTopOffset = 25.0
        static let progressViewHeight = 12.75
        static let titleLabelTopOffset = 24.0
        static let descriptionLabelTopOffset = 12.0
    }
    
    // MARK: - Properties
    
    private let currentVC: UIViewController?
    private let coordinator: CustomizingCoordinator?
    
    // MARK: - UI
    
    private lazy var exitButton = ExitButton(currentVC: currentVC, coordinator: coordinator)
    private let progressHStackView: CustomProgressHStackView
    private let titleLabel: CustomTitleLabel
    private let descriptionLabel: CustomDescriptionLabel?
    
    // MARK: - Initialize
    
    init(
        currentVC: UIViewController,
        coordinator: CustomizingCoordinator?,
        numerator: Float,
        title: String,
        description: String? = nil
    ) {
        self.currentVC = currentVC
        self.coordinator = coordinator
        self.progressHStackView = CustomProgressHStackView(numerator: numerator, denominator: 7)
        self.titleLabel = CustomTitleLabel(text: title)
        
        if let descriptionText = description {
            self.descriptionLabel = CustomDescriptionLabel(text: descriptionText, numberOfLines: 2)
        } else {
            self.descriptionLabel = nil
        }
        
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        backgroundColor = .white
        
        [
            exitButton,
            progressHStackView,
            titleLabel,
        ].forEach(addSubview(_:))
        addDescriptionLabelIfNeeded()
        setupAutoLayout()
    }
    
    private func addDescriptionLabelIfNeeded() {
        guard let descriptionLabel = descriptionLabel else { return }
        addSubview(descriptionLabel)
    }
}

extension CustomHeaderView {
    private func setupAutoLayout() {
        exitButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Metric.exitButtonTopOffset)
            $0.leading.equalToSuperview()
        }
        
        progressHStackView.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).offset(Metric.progressViewTopOffset)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Metric.progressViewHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressHStackView.snp.bottom).offset(Metric.titleLabelTopOffset)
            $0.leading.equalToSuperview()
            
            if descriptionLabel == nil {
                $0.bottom.equalToSuperview()
            }
        }
        
        if let descriptionLabel = descriptionLabel {
            descriptionLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(Metric.descriptionLabelTopOffset)
                $0.leading.bottom.equalToSuperview()
            }
        }
    }
}
