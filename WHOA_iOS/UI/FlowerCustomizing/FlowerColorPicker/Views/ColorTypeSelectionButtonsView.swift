//
//  ColorTypeSelectionButtonsView.swift
//  WHOA_iOS
//
//  Created by KSH on 9/6/24.
//

import UIKit
import Combine

final class ColorTypeSelectionButtonsView: UIView {
    
    // MARK: - Properties
    
    private let colorTypeSubject = PassthroughSubject<NumberOfColorsType, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var valuePublisher: AnyPublisher<NumberOfColorsType, Never> {
        return colorTypeSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UI
    
    private lazy var oneColorButton = buildColorTypeButton(colorType: .oneColor)
    private lazy var twoColorButton = buildColorTypeButton(colorType: .twoColor)
    private lazy var colorfulButton = buildColorTypeButton(colorType: .colorful)
    private lazy var pointColorButton = buildColorTypeButton(colorType: .pointColor)
    
    private lazy var colorTypeButtonHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            oneColorButton,
            twoColorButton,
            colorfulButton,
            pointColorButton,
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        [
            colorTypeButtonHStackView
        ].forEach(addSubview(_:))
        
        setupAutoLayout()
    }
    
    func updateButton(_ colorType: NumberOfColorsType) {
        resetAllButtons()
        
        guard let selectedButton = button(for: colorType) else { return }
        updateSelectedButton(selectedButton)
    }
    
    private func resetAllButtons() {
        [
            oneColorButton,
            twoColorButton,
            colorfulButton,
            pointColorButton
        ].forEach { button in
            button.setTitleColor(.gray08, for: .normal)
            button.titleLabel?.font = .Pretendard()
            button.layer.borderColor = UIColor.gray04.cgColor
        }
    }
    
    private func button(for colorType: NumberOfColorsType) -> UIButton? {
        switch colorType {
        case .oneColor, .none:
            return oneColorButton
        case .twoColor:
            return twoColorButton
        case .colorful:
            return colorfulButton
        case .pointColor:
            return pointColorButton
        }
    }
    
    private func updateSelectedButton(_ button: UIButton) {
        button.setTitleColor(.customPrimary, for: .normal)
        button.titleLabel?.font = .Pretendard(family: .SemiBold)
        button.layer.borderColor = UIColor.secondary03.cgColor
    }
    
    private func buildColorTypeButton(colorType: NumberOfColorsType) -> UIButton {
        let button = UIButton()
        button.setTitle(colorType.rawValue, for: .normal)
        button.titleLabel?.font = .Pretendard()
        button.setTitleColor(.gray08, for: .normal)
        button.backgroundColor = .gray01
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 14
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray04.cgColor
        
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.colorTypeSubject.send(colorType)
        }, for: .touchUpInside)
        return button
    }
}

// MARK: - AutoLayout

extension ColorTypeSelectionButtonsView {
    private func setupAutoLayout() {
        colorTypeButtonHStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
