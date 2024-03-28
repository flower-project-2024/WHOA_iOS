//
//  CustomDescriptionLabel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/7/24.
//

import UIKit

class CustomDescriptionLabel: UILabel {
    
    // MARK: - Initialization
    
    init(text: String, numberOfLines: Int = 1) {
        super.init(frame: .zero)
        
        setupView(text, numberOfLines)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupView(_ text: String, _ numberOfLines: Int) {
        self.text = text
        self.font = .Pretendard(size: 16, family: .Regular)
        self.textColor = .gray7
        self.numberOfLines = numberOfLines
        self.font = UIFont(name: "Pretendard-Regular", size: 16)
    }
}
