//
//  ColorChipButton.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/9/24.
//

import UIKit

class ColorChipButton: UIButton {
    init(colorCode: String) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = UIColor(hex: colorCode)
        config.cornerStyle = .dynamic
        config.background.cornerRadius = 15
        
        if colorCode == "#FDFFF8" {
            config.background.strokeWidth = 0.5
            config.background.strokeColor = UIColor(hex: "#CACDC2", alpha: 1)
        }
        self.configuration = config
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
