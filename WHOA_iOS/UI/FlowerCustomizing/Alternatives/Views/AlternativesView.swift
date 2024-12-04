//
//  AlternativesView.swift
//  WHOA_iOS
//
//  Created by KSH on 11/11/24.
//

import UIKit
import Combine

final class AlternativesView: UIView {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let colorOrientedButtonTopOffest = 32.0
        static let colorOrientedButtonHeightMultiplier = 0.16
        static let hashTagOrientedButtonTopOffset = 12.0
        static let nextButtonTopOffset = UIScreen.main.bounds.height < 670 ? 40.0 : 98.0
    }
    
    /// Attributes
    private enum Attributes {
        static let titleText = "선택한 꽃들이 없다면?"
        static let colorOrientedButtonTitle = "\(AlternativesType.colorOriented.rawValue)로 대체해주세요"
        static let hashTagOrientedButtonTitle = "\(AlternativesType.hashTagOriented.rawValue)로 대체해주세요"
        static let nextButtonText = "다음"
    }
    
    // MARK: - Properties
    
    private let alternativeSubject = PassthroughSubject<AlternativesType, Never>()
    private let nextButtonTappedSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var valuePublisher: AnyPublisher<AlternativesType, Never> {
        return alternativeSubject.eraseToAnyPublisher()
    }
    
    var nextButtonTappedPublisher: AnyPublisher<Void, Never> {
        nextButtonTappedSubject.eraseToAnyPublisher()
    }
    // MARK: - UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Attributes.titleText
        label.font = .Pretendard(size: 24, family: .SemiBold)
        label.textColor = .black
        return label
    }()
    
    private lazy var colorOrientedButton: SpacebarButton = {
        let button = SpacebarButton(title: Attributes.colorOrientedButtonTitle)
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.alternativeSubject.send(.colorOriented)
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var hashTagOrientedButton: SpacebarButton = {
        let button = SpacebarButton(title: Attributes.hashTagOrientedButtonTitle)
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.alternativeSubject.send(.hashTagOriented)
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(Attributes.nextButtonText, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.isEnabled = false
        
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.nextButtonTappedSubject.send()
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
            titleLabel,
            colorOrientedButton,
            hashTagOrientedButton,
            nextButton
        ].forEach(addSubview(_:))
        setupAutoLayout()
    }
    
    func updateButtonSelection(for alternative: AlternativesType) {
        let isColorSelected = (alternative == .colorOriented)
        let isHashTagSelected = (alternative == .hashTagOriented)
        
        colorOrientedButton.updateSelectionState(isSelected: isColorSelected)
        hashTagOrientedButton.updateSelectionState(isSelected: isHashTagSelected)
        configNextButtonState(isEnabled: alternative != .none)
    }
    
    private func configNextButtonState(isEnabled: Bool) {
        nextButton.isEnabled = isEnabled
        nextButton.setTitleColor( isEnabled ? .white : .gray05, for: .normal)
        nextButton.backgroundColor = isEnabled ? .black : .gray03
    }
}

// MARK: - AutoLayout

extension AlternativesView {
    private func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        colorOrientedButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Metric.colorOrientedButtonTopOffest)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.snp.width).multipliedBy(Metric.colorOrientedButtonHeightMultiplier)
        }
        
        hashTagOrientedButton.snp.makeConstraints {
            $0.top.equalTo(colorOrientedButton.snp.bottom).offset(Metric.hashTagOrientedButtonTopOffset)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(colorOrientedButton.snp.height)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(hashTagOrientedButton.snp.bottom).offset(Metric.nextButtonTopOffset)
            $0.height.equalTo(colorOrientedButton.snp.height)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
