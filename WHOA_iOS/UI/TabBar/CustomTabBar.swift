//
//  CustomTabBar.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 7/13/24.
//

import UIKit

final class CustomTabBar: UITabBar {
    
    // MARK: - Properties
    
    var customHeight: CGFloat = 60

    // MARK: - Functions
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = customHeight
        return sizeThatFits
    }
}
