//
//  CustomStartView.swift
//  WHOA_iOS
//
//  Created by KSH on 8/15/24.
//

import UIKit

final class CustomStartView: UIView {
    
    // MARK: - Properties
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 꽃다발을 만들까요?"
        label.textColor = .gray09
        label.font = .Pretendard(size: 16, family: .SemiBold)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = .Pretendard(size: 16, family: .SemiBold)
        textField.textColor = .black
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray04.cgColor
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 8.0
        return textField
    }()
    
    private let placeholder: UILabel = {
        let label = UILabel()
        label.text = "엄마생신 꽃다발"
        label.textColor = .gray05
        label.font = .Pretendard()
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("커스터마이징 시작하기", for: .normal)
        button.titleLabel?.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        button.setTitleColor(.gray05, for: .normal)
        button.backgroundColor = .gray03
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - Initialize
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        [
            descriptionLabel,
            textField,
            startButton
        ].forEach(addSubview(_:))
        
        textField.addSubview(placeholder)
        setupAutoLayout()
    }
    
}

// MARK: - AutoLayout

extension CustomStartView {
    private func setupAutoLayout() {
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(9)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(textField.snp.width).multipliedBy(0.14)
        }
        
        placeholder.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(28)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(textField.snp.height)
            $0.width.equalTo(startButton.snp.height).multipliedBy(3.5)
        }
    }
}
