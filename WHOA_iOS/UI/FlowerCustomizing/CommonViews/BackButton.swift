//
//  BackButton.swift
//  WHOA_iOS
//
//  Created by KSH on 2/8/24.
//

import UIKit

class BackButton: UIButton {
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupView() {
        self.setTitle("이전", for: .normal)
        self.setTitleColor(
            UIColor(
                red: 175/255,
                green: 175/255,
                blue: 175/255,
                alpha: 1.0
            ),
            for: .normal
        )
        self.backgroundColor = UIColor(
            red: 248/255,
            green: 248/255,
            blue: 248/255,
            alpha: 1.0
        )
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.isEnabled = false
    }
}
