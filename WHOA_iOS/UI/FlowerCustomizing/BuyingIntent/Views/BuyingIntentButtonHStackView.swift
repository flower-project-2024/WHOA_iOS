//
//  BuyingIntentButton.swift
//  WHOA_iOS
//
//  Created by KSH on 2/8/24.
//

import UIKit

class BuyingIntentButtonHStackView: UIStackView {
    
    // MARK: - Initialization
    
    init(button1: BuyingIntentButton, button2: BuyingIntentButton) {
        super.init(frame: .zero)
        
        setupView(button1, button2)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupView(_ button1: BuyingIntentButton, _ button2: BuyingIntentButton) {
        [
            button1,
            button2
        ].forEach { self.addArrangedSubview($0)}
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.spacing = 9
    }
}

class BuyingIntentButton: UIButton {
    
    // MARK: - Initialization
    
    init(text: String) {
        super.init(frame: .zero)
        
        setupButton(text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupButton(_ text: String) {
        var config = UIButton.Configuration.gray()
        config.baseForegroundColor = .black
        config.baseBackgroundColor = UIColor(
            red: 248/255,
            green: 248/255,
            blue: 248/255,
            alpha: 1.0
        )
        config.title = text
        
        config.image = UIImage(named: "IntentImage")
        config.imagePlacement = .top
        config.imagePadding = 6
        
        self.configuration = config
    }
}
