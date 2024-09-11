//
//  ColorSelectionResultView.swift
//  WHOA_iOS
//
//  Created by KSH on 9/7/24.
//

import UIKit

final class ColorSelectionResultView: UIView {
    
    // MARK: - Properties
    
    // MARK: - UI
    
    private let borderLine = ShadowBorderLine()
    
    private let colorChoiceLabel: UILabel = {
        let label = UILabel()
        label.text = "색을 선택해주세요"
        label.textColor = .gray09
        label.font = .Pretendard(size: 20, family: .Bold)
        return label
    }()
    
    private lazy var firstColorButton: UIButton = buildColorButton()
    private lazy var secondColorButton: UIButton = buildColorButton()
    private lazy var thirdColorButton: UIButton = buildColorButton()
    
    private lazy var colorButtonHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            firstColorButton,
            secondColorButton,
            thirdColorButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var firstCheckCircle: UIImageView = buildCheckCircle()
    private lazy var secondCheckCircle: UIImageView = buildCheckCircle()
    private lazy var thirdCheckCircle: UIImageView = buildCheckCircle()
    
    private lazy var pointColorLabel: UILabel = buildLabel(text: "포인트컬러")
    private lazy var baseColorLabel: UILabel = buildLabel(text: "베이스컬러")
    
    
    private lazy var pointVStackView: UIStackView = buildColorVStackView(
        label: pointColorLabel,
        checkCircle: firstCheckCircle
    )
    
    private lazy var baseVStackView: UIStackView = buildColorVStackView(
        label: baseColorLabel,
        checkCircle: secondCheckCircle
    )
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        [
            borderLine,
            colorChoiceLabel,
            colorButtonHStackView,
            pointVStackView,
            baseVStackView,
            thirdCheckCircle,
        ].forEach(addSubview(_:))
        
        setupAutoLayout()
    }
    
    func config(_ colorType: NumberOfColorsType) {
        reset()
        
        switch colorType {
        case .oneColor:
            break
        case .twoColor:
            show(secondColorButton, secondCheckCircle)
        case .colorful:
            show(secondColorButton, secondCheckCircle)
            show(thirdColorButton, thirdCheckCircle)
        case .pointColor:
            show(secondColorButton, secondCheckCircle)
            show(pointColorLabel, baseColorLabel)
        case .none:
            isHidden = true
        }
    }
    
    private func reset() {
        [
            secondColorButton,
            thirdColorButton,
            pointColorLabel,
            baseColorLabel,
            secondCheckCircle,
            thirdCheckCircle
        ].forEach{ $0.isHidden = true }
    }
    
    private func show(_ views: UIView...) {
        views.forEach { $0.isHidden = false }
    }
    
    private func buildColorButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray02
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 2
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
        label.isHidden = false
        return label
    }
    
    private func buildColorVStackView(label: UILabel, checkCircle: UIImageView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [
            label,
            checkCircle
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
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
        
        colorButtonHStackView.snp.makeConstraints {
            $0.top.equalTo(colorChoiceLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(96)
        }
        
        pointVStackView.snp.makeConstraints {
            $0.centerX.equalTo(firstColorButton.snp.centerX)
            $0.top.equalTo(firstColorButton.snp.bottom).offset(4)
        }
        
        baseVStackView.snp.makeConstraints {
            $0.centerX.equalTo(secondColorButton.snp.centerX)
            $0.top.equalTo(secondColorButton.snp.bottom).offset(4)
        }
        
        thirdCheckCircle.snp.makeConstraints {
            $0.centerX.equalTo(thirdColorButton.snp.centerX)
            $0.top.equalTo(thirdColorButton.snp.bottom).offset(4)
        }
    }
}
