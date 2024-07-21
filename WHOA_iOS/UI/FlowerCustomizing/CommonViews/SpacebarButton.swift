//
//  SpacebarButton.swift
//  WHOA_iOS
//
//  Created by KSH on 4/26/24.
//

import UIKit

final class SpacebarButton: UIButton {
    
    // MARK: - Initialization
    
    init(title: String) {
        super.init(frame: .zero)
        configureButton(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func configureButton(_ title: String) {
        self.titleLabel?.text = title
        self.configuration = configure(isSelected: false)
        self.contentHorizontalAlignment = .leading
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    func configure(isSelected: Bool) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.titleAlignment = .leading
        config.baseBackgroundColor = isSelected ? .second1.withAlphaComponent(0.2) : .gray02
        config.baseForegroundColor = .primary
        
        // Title
        var attString = AttributedString(self.titleLabel?.text ?? "")
        attString.font = isSelected ? .Pretendard(size: 16, family: .SemiBold) : .Pretendard(size: 16)
        config.attributedTitle = attString
        
        // Image
        let colorsConfig = UIImage.SymbolConfiguration(paletteColors: isSelected ? [.secondary03, .secondary03] : [.gray02, .gray05])
        config.image = UIImage(systemName: "button.programmable", withConfiguration: colorsConfig)
        config.imagePlacement = .leading
        config.imagePadding = 8
        
        return config
    }
}
