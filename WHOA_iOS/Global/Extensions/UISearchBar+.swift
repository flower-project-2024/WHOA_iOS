//
//  UISearchBar+.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 6/28/24.
//

import UIKit

extension UISearchBar {
    /// 검색바의 배경 색 바꾸는 함수 (디폴트 색상 = gray03)
    func setBackgroundColor(color: UIColor = .gray03, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.setSearchFieldBackgroundImage(image, for: .normal)
    }
    
}
