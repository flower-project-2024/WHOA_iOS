//
//  UIImage+.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 6/28/24.
//

import UIKit

extension UIImage {
    func resizeImage(size: CGSize) -> UIImage {
      let originalSize = self.size
      let ratio: CGFloat = {
          return originalSize.width > originalSize.height ? 1 / (size.width / originalSize.width) :
                                                            1 / (size.height / originalSize.height)
      }()

      return UIImage(cgImage: self.cgImage!, scale: self.scale * ratio, orientation: self.imageOrientation)
    }
}
