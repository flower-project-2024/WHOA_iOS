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
}
