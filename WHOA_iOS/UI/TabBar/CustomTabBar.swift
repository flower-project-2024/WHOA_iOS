//
//  CustomTabBar.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 7/13/24.
//

import UIKit

class CustomTabBar: UITabBar {
    var customHeight: CGFloat = 60 // 원하는 높이 설정

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = customHeight
        return sizeThatFits
    }
}
