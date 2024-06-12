//
//  NumberOfColorsBox.swift
//  WHOA_iOS
//
//  Created by KSH on 6/7/24.
//

import UIKit
import SnapKit

class NumberOfColorsBox: UIView {
    
    // MARK: - Properties
    
    let colorSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = "조합"
        label.textColor = .gray9
        label.font = UIFont.Pretendard(size: 16, family: .SemiBold)
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
        backgroundColor = .gray2
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        addSubview(colorSelectionLabel)
        addSubview(chevronImageView)
        
        setupAutoLayout()
    }
}

extension NumberOfColorsBox {
    private func setupAutoLayout() {
        colorSelectionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
