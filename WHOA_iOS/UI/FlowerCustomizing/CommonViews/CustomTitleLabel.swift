//
//  CustomTitleLabel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/7/24.
//

import UIKit

class CustomTitleLabel: UILabel {
    
    // MARK: - Initialization
    
    init(text: String) {
        super.init(frame: .zero)
        
        setupView(text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupView(_ text: String) {
        self.text = text
        self.font = .Pretendard(size: 24, family: .SemiBold)
        self.textColor = .black
        self.numberOfLines = 0
        
    }
}
