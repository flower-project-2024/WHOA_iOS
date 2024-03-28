//
//  ColorSelectionButton.swift
//  WHOA_iOS
//
//  Created by KSH on 3/28/24.
//

import UIKit

class ColorSelectionButton: UIButton {
    
    var isActive: Bool = false {
        didSet {
            updateButtonState()
        }
    }
    
    // MARK: - Initialization
    
    init(_ numberOfColorsType: NumberOfColorsType) {
        super.init(frame: .zero)
        
        setupView(numberOfColorsType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupView(_ numberOfColorsType: NumberOfColorsType) {
        self.setTitle(numberOfColorsType.rawValue, for: .normal)
        self.titleLabel?.font = .Pretendard()
        self.backgroundColor = .gray1
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        updateButtonState()
    }
    
    private func updateButtonState() {
        self.layer.borderColor = isActive ? UIColor.secondary3.cgColor : UIColor.gray4.cgColor
        self.setTitleColor( isActive ? .black : .gray8, for: .normal)
    }
}

