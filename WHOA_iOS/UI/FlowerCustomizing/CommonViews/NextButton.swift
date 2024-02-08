//
//  NextButton.swift
//  WHOA_iOS
//
//  Created by KSH on 2/8/24.
//

import UIKit

class NextButton: UIButton {
    
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
        self.setTitle("다음", for: .normal)
        self.setTitleColor(
            UIColor(
                red: 104/255,
                green: 104/255,
                blue: 104/255,
                alpha: 1.0
            ),
            for: .normal
        )
        self.backgroundColor = UIColor(
            red: 207/255,
            green: 207/255,
            blue: 207/255,
            alpha: 1.0
        )
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.isEnabled = false
    }
}
