//
//  ColorChipButton.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/9/24.
//

import UIKit

class ColorChipButton: UIButton {
    init(colorCode: String){
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = UIColor(hexCode: colorCode)
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

extension UIColor {
    /* rgba 대신 hexcode를 사용해서 UIColor를 생성(서버에서 hexcode로 색상이 넘어오기 때문에) */
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
