//
//  PackagingSelectionView.swift
//  WHOA_iOS
//
//  Created by KSH on 11/13/24.
//

import UIKit
import Combine

final class PackagingSelectionView: UIView {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let spacebarButtonHeightMultiplier = 0.16
        static let myselfAssignButtonTopOffset = 12.0
        static let placeholderOffset = 20.0
    }
    
    /// Attributes
    private enum Attributes {
        static let managerAssignButtonTitle = "아니요, \(PackagingAssignType.managerAssign.rawValue)"
        static let myselfAssignButtonTitle = "네, \(PackagingAssignType.myselfAssign.rawValue)"
    }
    
    // MARK: - Properties
    
    private let packagingAssignSubject = PassthroughSubject<PackagingAssignType, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var valuePublisher: AnyPublisher<PackagingAssignType, Never> {
        return packagingAssignSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UI
    
    private lazy var managerAssignButton: SpacebarButton = {
        let button = SpacebarButton(title: Attributes.managerAssignButtonTitle)
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.packagingAssignSubject.send(.managerAssign)
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var myselfAssignButton: SpacebarButton = {
        let button = SpacebarButton(title: Attributes.myselfAssignButtonTitle)
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.packagingAssignSubject.send(.myselfAssign)
        }, for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        backgroundColor = .white
        [
            managerAssignButton,
            myselfAssignButton,
        ].forEach(addSubview(_:))
        setupAutoLayout()
    }
    
    func updateButtonSelection(for packagingAssign: PackagingAssignType) {
        let isManagerSelected = (packagingAssign == .managerAssign)
        let isMyselfSelected = (packagingAssign == .myselfAssign)
        
        managerAssignButton.updateSelectionState(isSelected: isManagerSelected)
        myselfAssignButton.updateSelectionState(isSelected: isMyselfSelected)
    }
}

// MARK: - AutoLayout

extension PackagingSelectionView {
    private func setupAutoLayout() {
        managerAssignButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.snp.width).multipliedBy(Metric.spacebarButtonHeightMultiplier)
        }
        
        myselfAssignButton.snp.makeConstraints {
            $0.top.equalTo(managerAssignButton.snp.bottom).offset(Metric.myselfAssignButtonTopOffset)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(managerAssignButton.snp.height)
        }
    }
}

