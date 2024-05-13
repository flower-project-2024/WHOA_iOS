//
//  BackButton.swift
//  WHOA_iOS
//
//  Created by KSH on 2/8/24.
//

import UIKit

class BackButton: UIButton {
    
    // MARK: - Initialization
    
    init(isActive: Bool) {
        super.init(frame: .zero)
        
        setupView()
        updateButtonState(isActive)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupView() {
        self.setTitle("이전", for: .normal)
        self.titleLabel?.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
    }
    
    private func updateButtonState(_ isActive: Bool) {
        self.isEnabled = isActive
        self.layer.borderColor = UIColor( isActive ? .black : .clear).cgColor
        self.setTitleColor( isActive ? .primary : .gray5, for: .normal)
        self.backgroundColor = isActive ? .white : .gray3
    }
}
