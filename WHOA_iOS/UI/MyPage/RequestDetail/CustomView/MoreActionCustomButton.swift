//
//  MoreActionCustomButton.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 10/6/24.
//

import UIKit

final class MoreActionCustomButton: UIButton {
    
    // MARK: - Properties
    
    private var hasBezel: Bool = false
    
    // MARK: - Init
    
    init(hasBezel: Bool, title: String, subtitle: String?) {
        self.hasBezel = hasBezel
        
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.filled()
        config.title = title
        config.attributedTitle?.font = hasBezel ? .Pretendard(size: 20, family: .SemiBold) : .Pretendard(size: 16, family: .SemiBold)
        
        if let subtitle = subtitle {
            config.subtitle = subtitle
            config.attributedSubtitle?.font = hasBezel ? .Pretendard(size: 16, family: .Regular) : .Pretendard()
        }
        
        config.titlePadding = 10.adjustedH()
        config.contentInsets = .init(top: 23.adjustedH(),
                                     leading: 33.adjusted(),
                                     bottom: 23.adjustedH(),
                                     trailing: 33.adjusted())
        config.baseForegroundColor = .primary
        config.baseBackgroundColor = .gray02
        config.background.cornerRadius = 8
        
        self.configuration = config
        self.contentHorizontalAlignment = .leading
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func changeTitleAndSubtitle(title: String, subtitle: String?) {
        self.configuration?.title = title
        self.configuration?.attributedTitle?.font = hasBezel ? .Pretendard(size: 20, family: .SemiBold) : .Pretendard(size: 16, family: .SemiBold)
        
        if let subtitle = subtitle {
            self.configuration?.subtitle = subtitle
            self.configuration?.attributedSubtitle?.font = hasBezel ? .Pretendard(size: 16, family: .Regular) : .Pretendard()
        }
    }
}
