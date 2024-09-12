//
//  ColorSelectionResultView.swift
//  WHOA_iOS
//
//  Created by KSH on 9/7/24.
//

import UIKit
import Combine

final class ColorSelectionResultView: UIView {
    
    // MARK: - Properties
    
    private let selectedButtonSubject = CurrentValueSubject<UIButton?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI
    
    private let borderLine = ShadowBorderLine()

    private let colorChoiceLabel: UILabel = {
        let label = UILabel()
        label.text = "색을 선택해주세요"
        label.textColor = .gray09
        label.font = .Pretendard(size: 20, family: .Bold)
        return label
    }()
    
    private lazy var firstColorButton = buildColorButton()
    private lazy var secondColorButton = buildColorButton()
    private lazy var thirdColorButton = buildColorButton()
    
    private lazy var firstCheckCircle = buildCheckCircle()
    private lazy var secondCheckCircle = buildCheckCircle()
    private lazy var thirdCheckCircle = buildCheckCircle()
    
    private lazy var pointColorLabel = buildLabel(text: "포인트컬러")
    private lazy var baseColorLabel = buildLabel(text: "베이스컬러")
    
    private lazy var pointVStackView = buildColorVStackView(
        button: firstColorButton,
        label: pointColorLabel,
        checkCircle: firstCheckCircle
    )
    
    private lazy var baseVStackView = buildColorVStackView(
        button: secondColorButton,
        label: baseColorLabel,
        checkCircle: secondCheckCircle
    )
    
    private lazy var thirdVStackView = buildColorVStackView(
        button: thirdColorButton,
        label: nil,
        checkCircle: thirdCheckCircle
    )
    
    private lazy var mainHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            pointVStackView,
            baseVStackView,
            thirdVStackView
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        [
            borderLine,
            colorChoiceLabel,
            mainHStackView,
        ].forEach(addSubview(_:))
        setupAutoLayout()
    }
    
    private func bind() {
        selectedButtonSubject
            .sink { [weak self] selectedButton in
                self?.resetUIState()
                self?.updateSelectedButton(selectedButton)
            }
            .store(in: &cancellables)
    }
    
    func config(_ colorType: NumberOfColorsType) {
        hideAllViews()
        resetUIState()
        
        switch colorType {
        case .oneColor: break
        case .twoColor: show(baseVStackView)
        case .colorful: show(baseVStackView, thirdVStackView)
        case .pointColor: show(baseVStackView, pointColorLabel, baseColorLabel)
        case .none: isHidden = true
        }
        
        updateSelectedButton(firstColorButton)
        selectedButtonSubject.send(firstColorButton)
    }
    
    func updateSelectedButton(_ selectedButton: UIButton?) {
        selectedButton?.layer.borderColor = UIColor.secondary03.cgColor
        
        switch selectedButton {
        case firstColorButton: firstCheckCircle.tintColor = .secondary03
        case secondColorButton: secondCheckCircle.tintColor = .secondary03
        case thirdColorButton: thirdCheckCircle.tintColor = .secondary03
        default: break
        }
    }
    
    private func resetUIState() {
        [
            firstColorButton,
            secondColorButton,
            thirdColorButton
        ].forEach { button in
            button.layer.borderColor = UIColor.clear.cgColor
        }
        
        [
            firstCheckCircle,
            secondCheckCircle,
            thirdCheckCircle
        ].forEach { imageView in
            imageView.tintColor = .gray05
        }
    }
    
    private func hideAllViews() {
        [
            baseVStackView,
            thirdVStackView,
            pointColorLabel,
            baseColorLabel
        ].forEach { $0.isHidden = true }
    }
    
    private func show(_ views: UIView...) {
        views.forEach { $0.isHidden = false }
    }
    
    private func buildColorButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray02
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 2
        
        button.addAction(UIAction { [weak self] action in
            if let button = action.sender as? UIButton {
                self?.selectedButtonSubject.send(button)
            }
        }, for: .touchUpInside)
        return button
    }
    
    private func buildCheckCircle() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle")
        imageView.tintColor = .gray05
        imageView.preferredSymbolConfiguration = .init(pointSize: 24)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    private func buildLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .gray07
        label.font = .Pretendard(size: 12, family: .SemiBold)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }
    
    private func buildColorVStackView(
        button: UIButton,
        label: UILabel?,
        checkCircle: UIImageView
    ) -> UIStackView {
        var arrangedSubviews: [UIView] = [button, checkCircle]
        if let label = label { arrangedSubviews.insert(label, at: 1) }
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 4
        return stackView
    }
}

// MARK: - AutoLayout

extension ColorSelectionResultView {
    private func setupAutoLayout() {
        borderLine.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        colorChoiceLabel.snp.makeConstraints {
            $0.top.equalTo(borderLine.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        [firstColorButton, secondColorButton, thirdColorButton].forEach { button in
            button.snp.makeConstraints {
                $0.height.equalTo(96)
            }
        }
        
        mainHStackView.snp.makeConstraints {
            $0.top.equalTo(colorChoiceLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
