//
//  RequestCustomButton.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/22/24.
//

import UIKit

final class RequestCustomButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.bordered()
        config.cornerStyle = .dynamic
        config.background.cornerRadius = 10
        config.contentInsets = .init(top: 10, leading: 12, bottom: 10, trailing: 12)
        config.background.strokeColor = .black
        config.baseBackgroundColor = .white
        config.background.strokeWidth = 1
        config.attributedTitle = AttributedString.init(title)
        config.attributedTitle?.font = UIFont.Pretendard(size: 14, family: .Medium)
        config.baseForegroundColor = .black
        
        self.configuration = config
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
