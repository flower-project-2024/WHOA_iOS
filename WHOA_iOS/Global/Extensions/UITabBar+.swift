//
//  UITabBar+.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/25/24.
//

import UIKit

extension UITabBar {
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
