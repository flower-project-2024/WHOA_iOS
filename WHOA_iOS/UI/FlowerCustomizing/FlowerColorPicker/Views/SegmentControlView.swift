//
//  SegmentControlView.swift
//  WHOA_iOS
//
//  Created by KSH on 9/7/24.
//

import UIKit
import Combine

final class SegmentControlView: UIView {
    
    // MARK: - Properties
    
    private let hexColorSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var valuePublisher: AnyPublisher<String, Never>  {
        return hexColorSubject.eraseToAnyPublisher()
    }
    
    private let segmentColors: [[UIColor]] = [
        [.default1, .default2, .default3, .default4, .default5, .default6, .default7, .default8],
        [.dark1, .dark2, .dark3, .dark4, .dark5, .dark6, .dark7, .dark8],
        [.light1, .light2, .light3, .light4, .light5, .light6, .light7, .light8]
    ]
    
    // MARK: - UI
    
    private lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["기본 색감", "진한 색감", "연한 색감"])
        segment.selectedSegmentIndex = 0
        
        // 기본 폰트
        let font = UIFont.Pretendard(family: .SemiBold)
        let normalAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.gray06
        ]
        segment.setTitleTextAttributes(normalAttributes, for: .normal)
        
        // 선택된 폰트
        let selectedAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.gray09
        ]
        segment.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        segment.addAction(UIAction(handler: { [weak self] _ in
            self?.segmentChanged(sender: segment)
        }), for: .valueChanged)
        return segment
    }()
    
    private lazy var colorButtons: [UIButton] = (0...7).map { i in buildColorButton(backgroundColor: segmentColors[0][i]) }
    
    private lazy var colorHstackView1 = buildColorStackView(
        views: Array(colorButtons[0...3]),
        axis: .horizontal
    )
    private lazy var colorHstackView2 = buildColorStackView(
        views: Array(colorButtons[4...7]),
        axis: .horizontal
    )
    private lazy var colorVStackView = buildColorStackView(
        views: [colorHstackView1, colorHstackView2],
        axis: .vertical
    )
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃집마다 가지고 있는 색들이 달라\n선택한 색감에 맞는 꽃으로 대체될 수 있습니다."
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
        isHidden = true
        
        [
            segmentControl,
            colorVStackView,
            descriptionLabel
        ].forEach(addSubview(_:))
        setupAutoLayout()
    }
    
    private func buildColorButton(
        cornerRadius: CGFloat = 10,
        backgroundColor: UIColor
    ) -> UIButton {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = cornerRadius
        button.backgroundColor = backgroundColor
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray04.cgColor
        
        button.addAction(UIAction { [weak self] action in
            if let button = action.sender as? UIButton,
               let color = button.backgroundColor {
                self?.hexColorSubject.send(color.toHexString())
                self?.updateSelectedButton(button)
            }
        }, for: .touchUpInside)
        return button
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
    
    private func segmentChanged(sender: UISegmentedControl) {
        let colors = segmentColors[sender.selectedSegmentIndex]
        zip(colorButtons, colors).forEach { button, color in
            button.backgroundColor = color
        }
    }
    
    private func updateSelectedButton(_ button: UIButton) {
        colorButtons.forEach{ $0.setImage(nil, for: .normal) }
        
        let btnColor = UIColor.paletteCheckButton
        let colorsConfig = UIImage.SymbolConfiguration(paletteColors: [.gray01, btnColor, btnColor])
        button.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: colorsConfig), for: .normal)
    }
}

// MARK: - AutoLayout

extension SegmentControlView {
    private func setupAutoLayout() {
        let vSpacing = 20
        
        segmentControl.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        colorVStackView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(vSpacing)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(colorVStackView.snp.width).multipliedBy(0.25)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(colorVStackView.snp.bottom).offset(vSpacing)
            $0.centerX.bottom.equalToSuperview()
        }
    }
}
