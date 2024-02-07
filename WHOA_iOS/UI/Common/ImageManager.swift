//
//  ImageManager.swift
//  WHOA_iOS
//
//  Created by KSH on 2/7/24.
//

import UIKit

final class ImageManager {
    
    /// 이미지 크기를 조정해주는 메서드입니다.
    static func resizeImage(image: UIImage, to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
