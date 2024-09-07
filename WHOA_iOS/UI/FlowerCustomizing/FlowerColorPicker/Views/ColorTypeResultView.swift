//
//  ColorTypeResultView.swift
//  WHOA_iOS
//
//  Created by KSH on 6/7/24.
//

import UIKit
import SnapKit

final class ColorTypeResultView: UIView {
    
    // MARK: - Properties
    
    // MARK: - UI
    
    let colorSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = "조합"
        label.textColor = .gray09
        label.font = .Pretendard(size: 16, family: .SemiBold)
        return label
    }()
    
    let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
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
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        [
            colorSelectionLabel,
            chevronImageView
        ].forEach(addSubview(_:))
        
        setupAutoLayout()
    }
}

// MARK: - AutoLayout

extension ColorTypeResultView {
    private func setupAutoLayout() {
        let sideMargin = 12
        
        colorSelectionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(sideMargin)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-sideMargin)
        }
    }
}
