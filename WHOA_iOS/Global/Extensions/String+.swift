//
//  String+.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 6/20/24.
//

import Foundation
import UIKit

extension String {
    func getFlowerManagementImage() -> UIImage {
        switch self {
        case "주의할 점":
            return UIImage.caution
        case "물 교체":
            return UIImage.changeWater
        case "환경 조성":
            return UIImage.createEnvironment
        case "드라이플라워":
            return UIImage.dryflower
        case "오랜 관상법":
            return UIImage.longerEnjoyment
        case "포푸리":
            return UIImage.potpurri
        case "압화":
            return UIImage.pressing
        case "보관법":
            return UIImage.storageMethod
        case "물 주기":
            return UIImage.watering
        default:
            return UIImage.caution
        }
    }
}
