//
//  CustomStartView.swift
//  WHOA_iOS
//
//  Created by KSH on 8/15/24.
//

import UIKit
import Combine

final class CustomStartView: UIView {
    
    // MARK: - Enum
    
    /// Metrics
    private enum Metric {
        static let textFieldTopOffset = 9.0
        static let textFieldMargin = 20.0
        static let textFieldHeightMultiplier = 0.14
        static let startButtonTopOffset = 28.0
        static let startButtonWidthMultiplier = 3.625
    }
    
    /// Attributes
    private enum Attributes {
        static let descriptionLabelText = "꽃다발 이름을 정해주세요."
        static let PlaceholderText = "엄마생신 꽃다발"
        static let startButtonText = "커스터마이징 시작하기"
    }
    
    // MARK: - Properties
    
    private let startButtonTappedSubject = PassthroughSubject<Void, Never>()
    private let textInputSubject = CurrentValueSubject<String, Never>("")
    private var cancellables = Set<AnyCancellable>()
    
    var textInputPublisher: AnyPublisher<String, Never> {
        textInputSubject.eraseToAnyPublisher()
    }
    
    var startButtonTappedPublisher: AnyPublisher<Void, Never> {
        startButtonTappedSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UI
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Attributes.descriptionLabelText
        label.textColor = .primary
        label.font = .Pretendard(size: 16, family: .SemiBold)
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = .Pretendard(size: 16)
        textField.textColor = .black
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray04.cgColor
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 8.0
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        
        // Placeholder
        textField.attributedPlaceholder = NSAttributedString(
            string: Attributes.PlaceholderText,
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.gray05,
                NSAttributedString.Key.font : UIFont.Pretendard()
            ]
        )
        return textField
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle(Attributes.startButtonText, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        button.setTitleColor(.gray05, for: .normal)
        button.backgroundColor = .gray03
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.isEnabled = false
        
        button.addAction(UIAction { [weak self] _ in
            self?.startButtonTappedSubject.send()
        }, for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialize
    
    init() {
        super.init(frame: .zero)
        setupUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        backgroundColor = .white
        
        [
            descriptionLabel,
            textField,
            startButton
        ].forEach(addSubview(_:))
        
        textField.delegate = self
        setupAutoLayout()
    }
    
    private func bind() {
        textField.publisher
            .sink { [weak self] text in
                self?.textInputSubject.send(text)
            }
            .store(in: &cancellables)
    }
    
    func clearTextField() {
        textInputSubject.send("")
        textField.text = ""
    }
    
    func updateButtonState(isEnabled: Bool) {
        startButton.isEnabled = isEnabled
        
        if isEnabled {
            startButton.backgroundColor = .black
            startButton.setTitleColor(.gray02, for: .normal)
        } else {
            startButton.backgroundColor = .gray03
            startButton.setTitleColor(.gray05, for: .normal)
        }
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
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(Metric.textFieldTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Metric.textFieldMargin)
            $0.height.equalTo(textField.snp.width).multipliedBy(Metric.textFieldHeightMultiplier)
        }
        
        startButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(Metric.startButtonTopOffset)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(textField.snp.height)
            $0.width.equalTo(startButton.snp.height).multipliedBy(Metric.startButtonWidthMultiplier)
        }
    }
}

// MARK: - UITextFieldDelegate

extension CustomStartView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
