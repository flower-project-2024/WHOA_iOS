//
//  RequestDetailStackView.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/14/24.
//

import UIKit

final class RequestDetailStackView: UIStackView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.axis = .vertical
        self.spacing = 8
        self.alignment = .leading
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
