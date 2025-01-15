//
//  Data+.swift
//  WHOA_iOS
//
//  Created by KSH on 12/17/24.
//

import Foundation

extension Data {
    func toImageFile(filename: String, type: String = "image/png") -> ImageFile {
        return ImageFile(filename: filename, data: self, type: type)
    }
}
