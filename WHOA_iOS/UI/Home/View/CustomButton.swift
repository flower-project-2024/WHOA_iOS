//
//  CustomButton.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/14/24.
//

import UIKit

class CustomButton: UIButton {
    enum CustomButtonType: String {
        case todaysFlower = "오늘의 추천 꽃 구경하기"
        case customizing = "커스터마이징 살펴보기"
    }
    
    init(buttonType: CustomButtonType) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.filled()
        config.background.cornerRadius = 10
        config.cornerStyle = .dynamic
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 26.5, bottom: 10, trailing: 26.5)
        config.attributedTitle = AttributedString.init(buttonType.rawValue)
        config.attributedTitle?.font = UIFont(name: "Pretendard-Bold", size: 13)
        config.image = UIImage(named: "ChevronRight")?.withRenderingMode(.alwaysTemplate)
        config.imagePlacement = .trailing
        config.imagePadding = 11
        
        // 오늘의 추천 꽃 버튼인 경우
        if buttonType == .todaysFlower {
            config.baseBackgroundColor = UIColor(named: "Primary")
            config.baseForegroundColor = UIColor(named: "Gray01")
        }
        
        // 커스터마이징 버튼인 경우
        else if buttonType == .customizing {
            config.image?.withTintColor(UIColor(named: "Primary")!)
            config.baseBackgroundColor = UIColor(named: "Secondary03")
            config.baseForegroundColor = UIColor(named: "Primary")
        }
                        
        self.configuration = config
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
