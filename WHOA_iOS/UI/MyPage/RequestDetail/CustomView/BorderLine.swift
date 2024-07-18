//
//  BorderLine.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/14/24.
//

import UIKit

final class BorderLine: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
