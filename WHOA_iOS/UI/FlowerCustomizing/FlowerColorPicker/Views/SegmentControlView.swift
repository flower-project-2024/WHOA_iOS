//
//  SegmentControlView.swift
//  WHOA_iOS
//
//  Created by KSH on 9/7/24.
//

import UIKit
import Combine

final class SegmentControlView: UIView {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let elementVerticalSpacing = 20.0
        static let colorVStackHeightMultiplier = 0.25
    }
    
    /// Attributes
    private enum Attributes {
        static let segmentItems = ["기본 색감", "진한 색감", "연한 색감"]
        static let descriptionLabelText = "꽃집마다 가지고 있는 색들이 달라\n선택한 색감에 맞는 꽃으로 대체될 수 있습니다."
        static let checkmarkImageName = "checkmark.circle.fill"
    }
    
    // MARK: - Properties
    
    private var selectedHexColor: String?
    private let hexColorSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var valuePublisher: AnyPublisher<String, Never>  {
        return hexColorSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UI
    
    private let segmentColors: [[UIColor]] = [
        [.default1, .default2, .default3, .default4, .default5, .default6, .default7, .default8],
        [.dark1, .dark2, .dark3, .dark4, .dark5, .dark6, .dark7, .dark8],
        [.light1, .light2, .light3, .light4, .light5, .light6, .light7, .light8]
    ]
    
    private lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: Attributes.segmentItems)
        segment.selectedSegmentIndex = 0
        configSegmentControl(segment)
        segment.addAction(UIAction(handler: segmentChanged), for: .valueChanged)
        return segment
    }()
    
    private lazy var colorButtons: [UIButton] = (0...7).map { i in
        buildColorButton(backgroundColor: segmentColors[0][i])
    }
    
    private lazy var colorVStackView: UIStackView = {
        let hStack1 = buildColorStackView(views: Array(colorButtons[0...3]), axis: .horizontal)
        let hStack2 = buildColorStackView(views: Array(colorButtons[4...7]), axis: .horizontal)
        return buildColorStackView(views: [hStack1, hStack2], axis: .vertical)
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Attributes.descriptionLabelText
        label.font = .Pretendard(size: 12)
        label.textColor = .gray07
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
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
            segmentControl,
            colorVStackView,
            descriptionLabel
        ].forEach(addSubview(_:))
        setupAutoLayout()
    }
    
    
    func bind(with selectedColorPublisher: AnyPublisher<String, Never>) {
        selectedColorPublisher
            .sink { [weak self] selectedColor in
                self?.selectedHexColor = selectedColor
                self?.updateCheckmark(for: selectedColor)
            }
            .store(in: &cancellables)
    }
    
    private func configSegmentControl(_ segment: UISegmentedControl) {
        let font = UIFont.Pretendard(family: .SemiBold)
        let normalAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.gray06
        ]
        segment.setTitleTextAttributes(normalAttributes, for: .normal)
        
        let selectedAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.gray09
        ]
        segment.setTitleTextAttributes(selectedAttributes, for: .selected)
    }
    
    private func updateCheckmark(for color: String) {
        if let button = colorButtons.first(where: { $0.backgroundColor?.toHexString() == color }) {
            updateSelectedButton(button)
        } else {
            resetColorButtons()
        }
    }
    
    private func resetColorButtons() {
        colorButtons.forEach { $0.setImage(nil, for: .normal) }
    }
    
    private func buildColorButton(backgroundColor: UIColor) -> UIButton {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = backgroundColor
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray04.cgColor
        button.addAction(UIAction(handler: buttonTapped), for: .touchUpInside)
        return button
    }
    
    private func buttonTapped(action: UIAction) {
        guard let button = action.sender as? UIButton,
              let color = button.backgroundColor else { return }
        hexColorSubject.send(color.toHexString())
    }
    
    private func buildColorStackView(
        views: [UIView],
        axis: NSLayoutConstraint.Axis
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }
    
    // MARK: - Actions
    
    private func segmentChanged(action: UIAction) {
        guard let segment = action.sender as? UISegmentedControl else { return }
        let colors = segmentColors[segment.selectedSegmentIndex]
        zip(colorButtons, colors).forEach { button, color in
            button.backgroundColor = color
        }
        
        if let selectedHexColor = selectedHexColor {
            updateCheckmark(for: selectedHexColor)
        } else {
            resetColorButtons()
        }
    }
    
    private func updateSelectedButton(_ button: UIButton) {
        resetColorButtons()
        let checkmarkImage = UIImage(
            systemName: Attributes.checkmarkImageName,
            withConfiguration: UIImage.SymbolConfiguration(
                paletteColors: [
                    .gray01,
                    UIColor.paletteCheckButton,
                    UIColor.paletteCheckButton
                ]
            )
        )
        button.setImage(checkmarkImage, for: .normal)
    }
}

// MARK: - AutoLayout

extension SegmentControlView {
    private func setupAutoLayout() {
        segmentControl.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        colorVStackView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(Metric.elementVerticalSpacing)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(colorVStackView.snp.width).multipliedBy(Metric.colorVStackHeightMultiplier)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(colorVStackView.snp.bottom).offset(Metric.elementVerticalSpacing)
            $0.centerX.bottom.equalToSuperview()
        }
    }
}
