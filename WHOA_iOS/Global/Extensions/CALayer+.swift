//
//  CALayer+.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/25/24.
//

import UIKit

extension CALayer {
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        width: CGFloat = 0,
        height: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: width, height: height)
        shadowRadius = blur
    }
    
    func applyShadowByUIBezierPath(
        color: UIColor = .black,
        alpha: Float = 0.5,
        offsetWidth: CGFloat = 0,
        offsetHeight: CGFloat = 0,
        shadowWidth: CGFloat = 0,
        shadowHeight: CGFloat = 2,
        blur: CGFloat = 4,
        x: CGFloat = 0,
        y: CGFloat = 0
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: offsetWidth, height: offsetHeight)
        shadowRadius = blur
        let shadowRect = CGRect(x: x, y: y, width: shadowWidth, height: shadowHeight)
        let shadowPath = UIBezierPath(rect: shadowRect).cgPath
        self.shadowPath = shadowPath
    }
}
