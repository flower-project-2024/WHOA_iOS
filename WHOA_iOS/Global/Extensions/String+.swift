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
    
    /// 숫자로 이루어진 String을 천 단위에 끊어 쉼표를 추가해 포맷팅해주는 메소드입니다. (ex. 3000 -> 3,000)
    /// - Returns: 천 단위에 ,(쉼표)가 들어간 새로운 문자열 (전달받은 String이 천 단위보다 작은 경우 원본 문자열을 리턴)
    mutating func formatNumberInThousands() -> String {
        if self.count > 3 {
            let thirdLastIndex = self.index(self.endIndex, offsetBy: -3)  // 뒤에서 3번째 인덱스 자리를 구함
            self.insert(",", at: thirdLastIndex)
            return self
        }
        else {
            return self
        }
    }
}
