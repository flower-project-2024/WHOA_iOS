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
        static let colorOrientedButtonTag = 0
        static let hashTagOrientedButtonTag = 1
    }
    
    // MARK: - Properties
    
    // MARK: - UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Attributes.titleText
        label.font = .Pretendard(size: 24, family: .SemiBold)
        label.textColor = .black
        return label
    }()
    
    private let colorOrientedButton: UIButton = {
        let button = SpacebarButton(title: Attributes.colorOrientedButtonTitle)
        button.tag = Attributes.colorOrientedButtonTag
        return button
    }()
    
    private let hashTagOrientedButton: UIButton = {
        let button = SpacebarButton(title: Attributes.hashTagOrientedButtonTitle)
        button.tag = Attributes.hashTagOrientedButtonTag
        return button
    }()
    
    private let nextButton = NextButton()
    
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
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(colorOrientedButton.snp.height)
        }
    }
}
