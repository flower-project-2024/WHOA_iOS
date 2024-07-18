//
//  FlowerLanguageLabel.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/6/24.
//

import UIKit

/* 꽃말 해시 label custom */
final class HashTagCustomLabel: UILabel {
    private var padding = UIEdgeInsets(top: 3.5, left: 10, bottom: 3.5, right: 10)

    // 생성 시 padding을 설정할 수 있도록
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        self.backgroundColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.00)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // padding 변경
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    // padding을 변경한다고 intrinsicContentSize가 변경되지 않기 때문에 intrinsicContentSize 업데이트
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
