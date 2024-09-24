//
//  ColorTypeResultView.swift
//  WHOA_iOS
//
//  Created by KSH on 6/7/24.
//

import UIKit
import SnapKit

final class ColorTypeResultView: UIView {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let cornerRadius = 10.0
        static let sideMargin = 12.0
    }
    
    /// Attributes
    private enum Attributes {
        static let defaultLabelText = "조합"
        static let chevronDownImage = "chevron.down"
        static let chevronUpImage = "chevron.up"
    }
    
    // MARK: - Properties
    
    // MARK: - UI
    
    let colorSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = Attributes.defaultLabelText
        label.textColor = .gray09
        label.font = .Pretendard(size: 16, family: .SemiBold)
        return label
    }()
    
    let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Attributes.chevronDownImage)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        backgroundColor = .gray02
        layer.cornerRadius = Metric.cornerRadius
        layer.masksToBounds = true
        
        [
            colorSelectionLabel,
            chevronImageView
        ].forEach(addSubview(_:))
        
        setupAutoLayout()
    }
    
    func updateChevronImage(isExpanded: Bool) {
        let chevronImage = isExpanded ? Attributes.chevronUpImage : Attributes.chevronDownImage
        chevronImageView.image = UIImage(systemName: chevronImage)
    }
    
    func updateSelectionLabel(_ colorType: NumberOfColorsType) {
        colorSelectionLabel.text = (colorType == .none) ? Attributes.defaultLabelText : colorType.rawValue
    }
}

// MARK: - AutoLayout

extension ColorTypeResultView {
    private func setupAutoLayout() {
        colorSelectionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Metric.sideMargin)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-Metric.sideMargin)
        }
    }
}
