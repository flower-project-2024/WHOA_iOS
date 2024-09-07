//
//  ColorTypeSelectionButtonsView.swift
//  WHOA_iOS
//
//  Created by KSH on 9/6/24.
//

import UIKit

final class ColorTypeSelectionButtonsView: UIView {
    
    // MARK: - Properties
    
    // MARK: - UI
    
    private lazy var oneColorButton = buildColorTypeButton(colorType: .oneColor)
    private lazy var twoColorButton = buildColorTypeButton(colorType: .oneColor)
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
        stackView.isHidden = false
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
    
    private func buildColorTypeButton(colorType: NumberOfColorsType) -> UIButton {
        let button = UIButton()
        button.setTitle(colorType.rawValue, for: .normal)
        button.titleLabel?.font = .Pretendard()
        button.setTitleColor(.gray08, for: .normal)
        button.backgroundColor = .gray01
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray04.cgColor
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
