//
//  ShadowBorderLine.swift
//  WHOA_iOS
//
//  Created by KSH on 5/16/24.
//

import UIKit

final class ShadowBorderLine: UIView {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Functions
    
    private func setupView() {
        backgroundColor = .gray01
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 1
        layer.masksToBounds = false
    }
    
}
