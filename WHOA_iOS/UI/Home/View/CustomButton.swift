//
//  CustomButton.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/14/24.
//

import UIKit

final class CustomButton: UIButton {
    
    // MARK: - CustomButtonType
    
    enum CustomButtonType: String {
        case todaysFlower = "오늘의 추천 꽃 구경하기"
        case customizing = "커스터마이징 살펴보기"
    }
    
    // MARK: - Init
    
    init(buttonType: CustomButtonType) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.filled()
        config.background.cornerRadius = 10
        config.cornerStyle = .dynamic
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        config.attributedTitle = AttributedString.init(buttonType.rawValue)
        config.attributedTitle?.font = UIFont.Pretendard(size: 13, family: .Bold)
        config.image = UIImage.chevronRight.withRenderingMode(.alwaysTemplate)
        config.imagePlacement = .trailing
        config.imagePadding = 11
        
        // 오늘의 추천 꽃 버튼인 경우
        if buttonType == .todaysFlower {
            config.baseBackgroundColor = UIColor.primary
            config.baseForegroundColor = UIColor.gray01
        }
        
        // 커스터마이징 버튼인 경우
        else if buttonType == .customizing {
            config.image?.withTintColor(UIColor.primary)
            config.baseBackgroundColor = UIColor.secondary03
            config.baseForegroundColor = UIColor.primary
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
