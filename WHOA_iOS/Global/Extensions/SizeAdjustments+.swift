//
//  SizeAdjustments+.swift
//  WHOA_iOS
//
//  Created by KSH on 7/12/24.
//

import UIKit

/**
 - Description:
 스크린 너비를 기준으로 디자인이 나왔을 때 현재 기기의 스크린 사이즈에 비례하는 수치를 Return한다.
 디폴트는 아이폰 13 기준 해상도입니다.
 
 - Note:
 기기별 대응에 사용하면 된다.
 ex) (size: 20.adjusted())
 
     아이폰 15 Pro 기준
     (20.adjusted(basedOnWidth: 393))
     (20.adjusted(basedOnHeight: 852))
 */

extension CGFloat {
    func adjusted(basedOnWidth width: CGFloat = 375) -> CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / width
        return self * ratio
    }
    
    func adjustedH(basedOnHeight height: CGFloat = 812) -> CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / height
        return self * ratio
    }
}

extension Double {
    func adjusted(basedOnWidth width: Double = 375) -> Double {
        let ratio: Double = Double(UIScreen.main.bounds.width) / width
        return self * ratio
    }
    
    func adjustedH(basedOnHeight height: Double = 812) -> Double {
        let ratio: Double = Double(UIScreen.main.bounds.height) / height
        return self * ratio
    }
}
