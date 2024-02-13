//
//  ColorChipButton.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/9/24.
//

import UIKit

class ColorChipButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .red
        config.background.strokeColor = .black
        config.background.strokeWidth = 1
        config.cornerStyle = .dynamic
        config.background.cornerRadius = 15
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
