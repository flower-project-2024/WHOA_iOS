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
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
    }
    
    private func updateButtonState(_ isActive: Bool) {
        self.isEnabled = isActive
        self.layer.borderColor = UIColor( isActive ? .black : .clear).cgColor
        
        self.setTitleColor( isActive ? .black : UIColor(
            red: 175/255,
            green: 175/255,
            blue: 175/255,
            alpha: 1.0
        ), for: .normal
        )
        self.backgroundColor = isActive ? .white : UIColor(
            red: 248/255,
            green: 248/255,
            blue: 248/255,
            alpha: 1.0
        )
    }
}
