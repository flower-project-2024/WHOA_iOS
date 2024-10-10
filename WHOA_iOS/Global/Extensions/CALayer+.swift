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
    
    /// UIBezierPath를 사용해서 특정 부분에만 그림자를 넣는 메소드
    /// - Parameters:
    ///   - color: 그림자의 색상
    ///   - alpha: 그림자 색상의 투명도
    ///   - offsetWidth: shadow offset의 width
    ///   - offsetHeight: shadow offset의 height
    ///   - shadowWidth: 그림자 직사각형의 width
    ///   - shadowHeight: 그림자 직사각형의 height
    ///   - blur: shadowRadius 값
    ///   - x: 그림자가 시작하는 좌표의 x 값
    ///   - y: 그림자가 시작하는 좌표의 y 값
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
