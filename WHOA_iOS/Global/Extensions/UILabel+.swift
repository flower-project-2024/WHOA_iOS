//
//  UILabel+.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 6/30/24.
//

import UIKit

extension UILabel {
    func setLineSpacing(spacing: CGFloat) {
        guard let text = text else { return }

        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
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
