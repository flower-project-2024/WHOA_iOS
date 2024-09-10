//
//  CustomBottomView.swift
//  WHOA_iOS
//
//  Created by KSH on 7/27/24.
//

import UIKit
import Combine

final class CustomBottomView: UIView {
    
    // MARK: - Properties
    
    enum ButtonState {
        case disabled
        case enabled
        case hidden
    }
    
    private let backButtonTappedSubject = PassthroughSubject<Void, Never>()
    private let nextButtonTappedSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var backButtonTappedPublisher: AnyPublisher<Void, Never> {
        backButtonTappedSubject.eraseToAnyPublisher()
    }
    
    var nextButtonTappedPublisher: AnyPublisher<Void, Never> {
        nextButtonTappedSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UI
    
    private let borderLine = ShadowBorderLine()
    
    private lazy var backButton: UIButton = {
        let button = buildMoveButton(title: "이전")
        button.layer.borderWidth = 1
        button.addAction(UIAction { [weak self] _ in
            self?.backButtonTappedSubject.send()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = buildMoveButton(title: "다음")
        button.addAction(UIAction { [weak self] _ in
            self?.nextButtonTappedSubject.send()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var navigationHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [backButton, nextButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 9
        return stackView
    }()
    
    // MARK: - Initialize
    
    init(backButtonState: ButtonState, nextButtonEnabled: Bool) {
        super.init(frame: .zero)
        configBackButton(backButtonState)
        configNextButton(nextButtonEnabled)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        backgroundColor = .white
        
        [
            borderLine,
            navigationHStackView
        ].forEach(addSubview(_:))
        
        setupAutoLayout()
    }
    
    private func buildMoveButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.setTitleColor(.gray05, for: .normal)
        return button
    }
    
    private func configBackButton(_ backButtonState: ButtonState) {
        switch backButtonState {
        case .enabled:
            backButton.isEnabled = true
            backButton.backgroundColor = .gray01
            backButton.setTitleColor(.primary, for: .normal)
            backButton.layer.borderColor = UIColor.primary.cgColor
        case .disabled:
            backButton.isEnabled = false
            backButton.backgroundColor = .gray03
            backButton.setTitleColor(.gray05, for: .normal)
            backButton.layer.borderColor = UIColor.clear.cgColor
        case .hidden:
            backButton.isHidden = true
        }
    }
    
    private func configNextButton(_ nextButtonState: Bool) {
        nextButton.isEnabled = nextButtonState
        nextButton.backgroundColor = nextButtonState ? .primary : .gray03
        nextButton.setTitleColor(nextButtonState ? .gray02 : .gray05, for: .normal)
    }
}

// MARK: - AutoLayout

extension CustomBottomView {
    private func setupAutoLayout() {
        let horizontalPadding: CGFloat = 18
        
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
            $0.leading.equalToSuperview().offset(horizontalPadding)
            $0.trailing.equalToSuperview().offset(-horizontalPadding)
            $0.bottom.equalToSuperview()
        }
    }
}
