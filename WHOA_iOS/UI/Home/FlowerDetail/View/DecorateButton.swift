//
//  DecorateButton.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/31/24.
//

import UIKit

class DecorateButton: UIButton {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var config = UIButton.Configuration.filled()
        config.title = "이 꽃으로 꾸미기"
        config.attributedTitle?.font = .Pretendard(size: 16, family: .SemiBold)
        config.background.backgroundColor = UIColor.customPrimary
        config.background.cornerRadius = 10
        config.contentInsets = .init(top: 17, leading: 15, bottom: 17, trailing: 15)
        
        configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
