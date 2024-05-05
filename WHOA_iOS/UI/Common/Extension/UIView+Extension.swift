//
//  UIView+Extension.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/19/24.
//

import UIKit

extension UIView{
    /// UIView를 이미지로 변환하는 함수
    /// - Returns: 뷰 내용을 담은 이미지
    func transfromToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        defer {
            UIGraphicsEndImageContext()
        }
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        return nil
    }
}
