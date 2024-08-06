//
//  CustomBottomView.swift
//  WHOA_iOS
//
//  Created by KSH on 7/27/24.
//

import UIKit

class CustomBottomView: UIView {
    
    // MARK: - UI
    
    private let borderLine = ShadowBorderLine()
    let backButton = BackButton(isActive: false)
    let nextButton = NextButton()
    
    private lazy var navigationHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            backButton,
            nextButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 9
        return stackView
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
            borderLine,
            navigationHStackView
        ].forEach(addSubview(_:))
        
        setupAutoLayout()
    }
}

// MARK: - AutoLayout

extension CustomBottomView {
    private func setupAutoLayout() {
        borderLine.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(backButton.snp.width).multipliedBy(0.5)
        }
        
        navigationHStackView.snp.makeConstraints {
            $0.top.equalTo(borderLine.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-18)
            $0.bottom.equalToSuperview()
        }
    }
}
