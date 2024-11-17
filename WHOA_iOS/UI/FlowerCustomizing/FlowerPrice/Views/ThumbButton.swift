//
//  ThumbButton.swift
//  WHOA_iOS
//
//  Created by KSH on 11/17/24.
//

import UIKit

final class ThumbButton: UIButton {
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        self.backgroundColor = .white
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.secondary03.cgColor
    }
}
