//
//  UILabel+.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 6/30/24.
//

import UIKit

extension UILabel {
    
    /// UILabel에 line height를 적용하는 함수입니다.
    /// - Parameter lineHeight: 적용하려는 line height 백분율 값 (피그마에 있는 값)
    func setLineHeight(lineHeight: CGFloat) {
        guard let text = text else { return }

        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        let lineheight = font.lineHeight / 100 * (lineHeight - 100) / 4  //font size * multiple        
        style.lineSpacing = lineheight
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
    
    /// UILabel에 자간을 설정하는 함수입니다.
    func setLetterSpacing(_ spacing: Double) {
        guard let text = text else { return }
        
        let kernValue = self.font.pointSize * CGFloat(spacing)
        
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttribute(
            NSAttributedString.Key.kern,
            value: kernValue,
            range: NSRange(location: 0, length: attributedString.length)
        )
            
        attributedText = attributedString
    }
}
