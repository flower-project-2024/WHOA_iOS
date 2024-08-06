//
//  CustomHeaderView.swift
//  WHOA_iOS
//
//  Created by KSH on 7/27/24.
//

import UIKit

final class CustomHeaderView: UIView {
    
    // MARK: - Properties
    
    let currentVC: UIViewController?
    let coordinator: CustomizingCoordinator?
    
    private lazy var exitButton = ExitButton(currentVC: currentVC, coordinator: coordinator)
    private let progressHStackView = CustomProgressHStackView(numerator: 1, denominator: 7)
    private let titleLabel = CustomTitleLabel(text: "꽃다발 구매 목적")
    private let descriptionLabel = CustomDescriptionLabel(text: "선택한 목적에 맞는 꽃말을 가진\n꽃들을 추천해드릴게요", numberOfLines: 2)
    
    // MARK: - Initialize
    
    init(currentVC: UIViewController, coordinator: CustomizingCoordinator?) {
        self.currentVC = currentVC
        self.coordinator = coordinator
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        [
            exitButton,
            progressHStackView,
            titleLabel,
            descriptionLabel
        ].forEach(addSubview(_:))
        
        setupAutoLayout()
    }

}

extension CustomHeaderView {
    private func setupAutoLayout() {
        exitButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(17)
            $0.leading.equalToSuperview()
        }
        
        progressHStackView.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(12.75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressHStackView.snp.bottom).offset(24)
            $0.leading.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview()

        }
    }
    
}
