//
//  UIFont+.swift
//  WHOA_iOS
//
//  Created by KSH on 3/28/24.
//

import UIKit

extension UIFont {
    
    enum Family: String {
        case Black, Bold, ExtraBold, ExtraLight, Light, Medium, Regular, SemiBold, Thin
    }
    
    /// 기본 세팅 size: CGFloat = 14, family: Family = .Regular
    static func Pretendard(size: CGFloat = 14, family: Family = .Regular) -> UIFont {
        return UIFont(name: "Pretendard-\(family)", size: size)!
    }
}
