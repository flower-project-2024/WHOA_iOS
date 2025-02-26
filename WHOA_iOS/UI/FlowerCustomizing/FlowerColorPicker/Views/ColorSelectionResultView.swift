//
//  ColorSelectionResultView.swift
//  WHOA_iOS
//
//  Created by KSH on 9/7/24.
//

import UIKit
import Combine

final class ColorSelectionResultView: UIView {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let borderLineHeight = 4.0
        static let buttonHeight = 96.0
        static let elementVerticalSpacing = 24.0
        static let sideInset = 20.0
    }
    
    /// Attributes
    private enum Attributes {
        static let colorChoiceLabelText = "색을 선택해주세요"
        static let pointColorLabelText = "포인트컬러"
        static let baseColorLabelText = "베이스컬러"
        static let checkCircleImage = UIImage(systemName: "checkmark.circle")
    }
    
    // MARK: - Properties
    
    private let selectedButtonSubject = CurrentValueSubject<UIButton?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    
    var selectedButtonIndexPublisher: AnyPublisher<Int, Never> {
        return selectedButtonSubject
            .map { [weak self] button in
                switch button {
                case self?.firstResultButton: return 0
                case self?.secondResultButton: return 1
                case self?.thirdResultButton: return 2
                default: return 0
                }
            }
            .eraseToAnyPublisher()
    }
    
    var selectedColorPublisher: AnyPublisher<String, Never> {
        return selectedButtonSubject
            .compactMap({ button in
                button?.backgroundColor?.toHexString()
            })
            .eraseToAnyPublisher()
    }
    
    // MARK: - UI
    
    private let borderLine = ShadowBorderLine()
    
    private let colorChoiceLabel: UILabel = {
        let label = UILabel()
        label.text = Attributes.colorChoiceLabelText
        label.textColor = .gray09
        label.font = .Pretendard(size: 20, family: .Bold)
        return label
    }()
    
    private lazy var firstResultButton = buildColorButton()
    private lazy var secondResultButton = buildColorButton()
    private lazy var thirdResultButton = buildColorButton()
    
    private lazy var firstCheckCircle = buildCheckCircle()
    private lazy var secondCheckCircle = buildCheckCircle()
    private lazy var thirdCheckCircle = buildCheckCircle()
    
    private lazy var pointColorLabel = buildLabel(text: Attributes.pointColorLabelText)
    private lazy var baseColorLabel = buildLabel(text: Attributes.baseColorLabelText)
    
    private lazy var pointVStackView = buildColorVStackView(
        button: firstResultButton,
        label: pointColorLabel,
        checkCircle: firstCheckCircle
    )
    
    private lazy var baseVStackView = buildColorVStackView(
        button: secondResultButton,
        label: baseColorLabel,
        checkCircle: secondCheckCircle
    )
    
    private lazy var thirdVStackView = buildColorVStackView(
        button: thirdResultButton,
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
    
    func config(_ colorType: NumberOfColorsType) {
        hideAllViews()
        resetColor()
        
        switch colorType {
        case .oneColor, .none: break
        case .twoColor: show(baseVStackView)
        case .colorful: show(baseVStackView, thirdVStackView)
        case .pointColor: show(baseVStackView, pointColorLabel, baseColorLabel)
        }
        adjustButtonSizes(for: colorType)
        updateSelectedButton(firstResultButton)
    }
    
    private func updateSelectedButton(_ selectedButton: UIButton?) {
        resetUIState()
        selectedButtonSubject.send(selectedButton)
        selectedButton?.layer.borderColor = UIColor.secondary03.cgColor
        
        switch selectedButton {
        case firstResultButton: firstCheckCircle.tintColor = .secondary03
        case secondResultButton: secondCheckCircle.tintColor = .secondary03
        case thirdResultButton: thirdCheckCircle.tintColor = .secondary03
        default: break
        }
    }
    
    private func resetColor() {
        [
            firstResultButton,
            secondResultButton,
            thirdResultButton
        ].forEach { button in
            button.backgroundColor = .gray02
        }
    }
    
    func updateColorSelection(hexString: String, for index: Int) {
        guard hexString != "" else { return }
        let selectedButton: UIButton
        switch index {
        case 0: selectedButton = firstResultButton
        case 1: selectedButton = secondResultButton
        case 2: selectedButton = thirdResultButton
        default: selectedButton = thirdResultButton
        }
        selectedButton.backgroundColor = UIColor(hex: hexString)
        updateNextButtonSelection(after: selectedButton)
    }
    
    private func updateNextButtonSelection(after selectedButton: UIButton) {
        let buttonsWithStackViews: [(UIButton, UIStackView)] = [
            (firstResultButton, pointVStackView),
            (secondResultButton, baseVStackView),
            (thirdResultButton, thirdVStackView)
        ]
        
        let visibleButtons = buttonsWithStackViews
            .filter { !$0.1.isHidden }
            .map { $0.0 }
        
        guard let currentIndex = visibleButtons.firstIndex(of: selectedButton),
              currentIndex < visibleButtons.count - 1 else {
            return updateSelectedButton(visibleButtons.last)
        }
        
        updateSelectedButton(visibleButtons[currentIndex + 1])
    }
    
    private func resetUIState() {
        [
            firstResultButton,
            secondResultButton,
            thirdResultButton
        ].forEach { button in
            button.layer.borderColor = UIColor.gray02.cgColor
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
    
    func adjustButtonSizes(for colorType: NumberOfColorsType) {
        mainHStackView.distribution = (colorType == .pointColor) ? .fill : .fillEqually
        
        if colorType == .pointColor {
            firstResultButton.snp.makeConstraints {
                $0.width.equalTo(mainHStackView.snp.width).multipliedBy(0.318).priority(2)
            }
        }
    }
    
    private func buildColorButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray02
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.gray02.cgColor
        button.layer.borderWidth = 2
        
        button.addAction(UIAction { [weak self] _ in
            self?.updateSelectedButton(button)
        }, for: .touchUpInside)
        return button
    }
    
    private func buildCheckCircle() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = Attributes.checkCircleImage
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
            $0.height.equalTo(Metric.borderLineHeight)
        }
        
        colorChoiceLabel.snp.makeConstraints {
            $0.top.equalTo(borderLine.snp.bottom).offset(Metric.elementVerticalSpacing)
            $0.leading.equalToSuperview().offset(Metric.sideInset)
        }
        
        [firstResultButton, secondResultButton, thirdResultButton].forEach { button in
            button.snp.makeConstraints {
                $0.height.equalTo(Metric.buttonHeight)
            }
        }
        
        mainHStackView.snp.makeConstraints {
            $0.top.equalTo(colorChoiceLabel.snp.bottom).offset(Metric.elementVerticalSpacing)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideInset)
        }
    }
}
