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
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            updateSelection()
        }
    }
    
    // MARK: - Initialization
    
    init(purposeType: BuyingIntentType) {
        super.init(frame: .zero)
        
        setupUI(purposeType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI(_ purposeType: BuyingIntentType) {
        var config = UIButton.Configuration.gray()
        config.baseForegroundColor = .black
        config.baseBackgroundColor = UIColor(
            red: 248/255,
            green: 248/255,
            blue: 248/255,
            alpha: 1.0
        )
        config.title = purposeType.rawValue
        config.image = getPurposeImage(purposeType)
        config.imagePlacement = .top
        config.imagePadding = 10
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 1
        self.configuration = config
    }
    
    private func updateSelection() {
        layer.borderColor = isSelected ? UIColor.green.cgColor : UIColor.clear.cgColor
        self.backgroundColor = isSelected ? UIColor(red: 079/255, green: 234/255, blue: 191/255, alpha: 0.2) : UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
    }
    
    private func getPurposeImage(_ purposeType: BuyingIntentType) -> UIImage? {
        
        switch purposeType {
        case .affection:
            UIImage(named: "Affection")
        case .birthday:
            UIImage(named: "Birthday")
        case .gratitude:
            UIImage(named: "Gratitude")
        case .propose:
            UIImage(named: "Propose")
        case .party:
            UIImage(named: "Party")
        case .employment:
            UIImage(named: "Employment")
        case .promotion:
            UIImage(named: "Promotion")
        case .friendship:
            UIImage(named: "Friendship")
        }
    }
}
