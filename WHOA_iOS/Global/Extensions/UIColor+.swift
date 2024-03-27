//
//  UIColor+.swift
//  WHOA_iOS
//
//  Created by KSH on 3/28/24.
//

import UIKit

extension UIColor {
    static func custom(_ color: Palette) -> UIColor? {
        .init(named: color.rawValue)
    }
}
