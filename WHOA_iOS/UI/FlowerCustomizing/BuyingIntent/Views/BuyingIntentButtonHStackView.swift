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
        updateSelection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI(_ purposeType: BuyingIntentType) {
        var config = UIButton.Configuration.gray()
        config.baseBackgroundColor = .gray2
        config.title = purposeType.rawValue
        config.image = getPurposeImage(purposeType)
        config.imagePlacement = .top
        config.imagePadding = 10
        config.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.configuration = config
    }
    
    private func updateSelection() {
        layer.borderColor = isSelected ? UIColor.secondary3.cgColor : UIColor.clear.cgColor
        self.backgroundColor = isSelected ? .second1.withAlphaComponent(0.2) : .gray2
        self.titleLabel?.font = isSelected ? .Pretendard(size: 16, family: .SemiBold) : .Pretendard()
        self.configuration?.baseForegroundColor = isSelected ? .black : .gray8
        
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
