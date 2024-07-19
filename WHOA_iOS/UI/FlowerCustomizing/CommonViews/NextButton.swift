//
//  NextButton.swift
//  WHOA_iOS
//
//  Created by KSH on 2/8/24.
//

import UIKit

final class NextButton: UIButton {
    
    var isActive: Bool = false {
        didSet {
            updateButtonState()
        }
    }
    
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
        self.titleLabel?.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.isEnabled = false
        updateButtonState()
    }
    
    private func updateButtonState() {
        self.isEnabled = isActive
        self.setTitleColor( isActive ? .white : .gray05, for: .normal)
        self.backgroundColor = isActive ? .black : .gray03
    }
}
