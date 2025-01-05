//
//  RequestCustomButton.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/22/24.
//

import UIKit

final class RequestCustomButton: UIButton {
    
    // MARK: - Init
    
    init(title: String) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.bordered()
        config.cornerStyle = .dynamic
        config.background.cornerRadius = 10
        config.contentInsets = .init(top: 11.adjustedH(),
                                     leading: 27.adjusted(),
                                     bottom: 11.adjustedH(),
                                     trailing: 27.adjusted())
        
        if title == "수정" {
            config.baseBackgroundColor = .customPrimary
            config.baseForegroundColor = .gray01
        }
        else {
            config.baseBackgroundColor = .gray02
            config.baseForegroundColor = .gray08
        }
        config.attributedTitle = AttributedString.init(title)
        config.attributedTitle?.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        
        self.configuration = config
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
