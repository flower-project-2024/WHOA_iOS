//
//  ExitButton.swift
//  WHOA_iOS
//
//  Created by KSH on 2/9/24.
//

import UIKit

class ExitButton: UIImageView {
    
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
        self.image = UIImage(named: "xmark")
        self.tintColor = .black
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(exitButtonTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func exitButtonTapped() {
        print("exitButtonTapped")
    }
}
