//
//  CustomProgressView.swift
//  WHOA_iOS
//
//  Created by KSH on 2/7/24.
//

import UIKit

class CustomProgressHStackView: UIStackView {
    
    // MARK: - Initialization
    
    init(numerator: Float, denominator: Float) {
        super.init(frame: .zero)
        
        setupView(numerator, denominator)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupView(_ numerator: Float, _ denominator: Float) {
        let percentageText = "\(Int(numerator)) / \(Int(denominator))"
        let progressView = CustomProgressView(percentage: numerator / denominator)
        let progressLabel = CustomProgressLabel(percentageText: percentageText)
        
        [
            progressView,
            progressLabel
        ].forEach { self.addArrangedSubview($0)}
        self.axis = .horizontal
        self.spacing = 7.5
    }
}

class CustomProgressView: UIProgressView {
    
    // MARK: - Initialization
    
    init(percentage: Float) {
        super.init(frame: .zero)
        
        setupView(percentage: percentage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupView(percentage: Float) {
        self.trackTintColor = UIColor(
            red: 244/255,
            green: 244/255,
            blue: 244/255,
            alpha: 1.0
        )
        self.progressTintColor = .black
        self.progress = percentage
        self.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
    }
}

class CustomProgressLabel: UILabel {
    
    // MARK: - Initialization
    
    init(percentageText: String) {
        super.init(frame: .zero)
        
        setupView(percentageText: percentageText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupView(percentageText: String) {
        let fullString = NSMutableAttributedString(string: percentageText)
        let grayAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        
        fullString.addAttributes(grayAttributes, range: (percentageText as NSString).range(of: "\(percentageText.split(separator: "/").first ?? "1")"))
        
        self.textColor = UIColor(
            red: 189/255,
            green: 189/255,
            blue: 189/255,
            alpha: 1.0
        )
        self.attributedText = fullString
    }
}
