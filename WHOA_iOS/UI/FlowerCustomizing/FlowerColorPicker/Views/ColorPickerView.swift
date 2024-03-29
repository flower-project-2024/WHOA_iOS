//
//  ColorPickerView.swift
//  WHOA_iOS
//
//  Created by KSH on 2/18/24.
//

import UIKit
import SnapKit

protocol FlowerColorPickerDelegate: AnyObject {
    func isNextButtonEnabled(isEnabled: Bool)
}

class ColorPickerView: UIView {
    
    // MARK: - Properties
    
    private var viewModel: FlowerColorPickerViewModel
    private var selectedButton: UIButton?
    private var selectedColor: UIColor?
    private var flowerColorPickerButtons: [UIButton] = []
    private var colorPaletteButtons: [UIButton] = []
    private var previousSegmentIndex: Int = 0
    private lazy var selectedFlowerColorPickerButton: UIButton = flowerColorPickerButton
    
    weak var delegate: FlowerColorPickerDelegate?
    
    var numberOfColors: NumberOfColorsType {
        didSet {
            flowerColorPickerButtonCount(numberOfColors: numberOfColors)
            updateNextButtonState()
        }
    }
    
    // MARK: - Properties
    
    private let colorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "색을 선택해주세요"
        label.font = .Pretendard(size: 20, family: .Bold)
        return label
    }()
    
    private let flowerColorPickerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = UIColor.systemMint
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.systemMint.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(FlowerColorPickerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let flowerColorPickerButton2: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.app"), for: .normal)
        button.tintColor = UIColor.lightGray
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(FlowerColorPickerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let flowerColorPickerButton3: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.app"), for: .normal)
        button.tintColor = UIColor.lightGray
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(FlowerColorPickerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var flowerColorPickerButtonHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        flowerColorPickerButtons.forEach { stackView.addArrangedSubview($0) }
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["기본 색감", "진한 색감", "연한 색감"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.center = CGPoint(x: self.frame.width/2, y: 400)
        return segmentedControl
    }()
    
    private let colorPaletteButton1: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPaletteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPaletteButton2: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPaletteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPaletteButton3: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPaletteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPaletteButton4: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPaletteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var colorPaletteHStack = {
        let stackView = UIStackView()
        [
            colorPaletteButton1,
            colorPaletteButton2,
            colorPaletteButton3,
            colorPaletteButton4,
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let colorPaletteButton5: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPaletteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPaletteButton6: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPaletteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPaletteButton7: UIButton = {
        let button = UIButton()
        button.backgroundColor = .purple
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPaletteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPaletteButton8: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(colorPaletteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var colorPaletteHStack2 = {
        let stackView = UIStackView()
        [
            colorPaletteButton5,
            colorPaletteButton6,
            colorPaletteButton7,
            colorPaletteButton8,
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var colorPaletteVStack: UIStackView = {
        let stackView = UIStackView()
        [
            colorPaletteHStack,
            colorPaletteHStack2
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Initialize
    
    init(viewModel: FlowerColorPickerViewModel, numberOfColors: NumberOfColorsType) {
        self.viewModel = viewModel
        self.numberOfColors = numberOfColors
        super.init(frame: .zero)
        
        config()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        addSubview(colorDescriptionLabel)
        addSubview(flowerColorPickerButtonHStackView)
        addSubview(segmentControl)
        addSubview(colorPaletteVStack)
        
        setupAutoLayout()
        setupSegmentControl()
    }
    
    private func setupSegmentControl() {
        self.segmentControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        didChangeValue(segment: self.segmentControl)
    }
    
    private func config() {
        colorPaletteButtons = [
            colorPaletteButton1,
            colorPaletteButton2,
            colorPaletteButton3,
            colorPaletteButton4,
            colorPaletteButton5,
            colorPaletteButton6,
            colorPaletteButton7,
            colorPaletteButton8
        ]
        
        flowerColorPickerButtons = [
            flowerColorPickerButton,
            flowerColorPickerButton2,
            flowerColorPickerButton3
        ]
    }
    
    private func selectedFlowerColorPickerButtonUI(button: UIButton) {
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.layer.borderColor = UIColor.systemMint.cgColor
        button.tintColor = .systemMint
    }
    
    private func unSelectedFlowerColorPickerButtonUI(button: UIButton) {
        button.setImage(UIImage(systemName: "plus.app"), for: .normal)
        button.layer.borderColor = UIColor.gray.cgColor
        button.tintColor = .lightGray
    }
    
    // 도화지 클릭 시 해당 도화지가 이미 선택된 도화지가 아니면 UI(체크마크, 테두리색)를 변경해주는 메서드
    private func updateSelectedFlowerColorPickerButton(with selectedButton: UIButton) {
        if selectedFlowerColorPickerButton != selectedButton {
            selectedFlowerColorPickerButton = selectedButton
            selectedFlowerColorPickerButtonUI(button: selectedButton)
        }
    }
    
    // 도화지 클릭 시 클릭되지 않은 나머지 도화지들의 UI를 변경해주는 로직
    private func updateOtherFlowerColorPickerButtons() {
        for button in flowerColorPickerButtons {
            if button != selectedFlowerColorPickerButton {
                if button.backgroundColor != nil {
                    button.setImage(nil, for: .normal)
                } else {
                    unSelectedFlowerColorPickerButtonUI(button: button)
                }
            }
        }
    }
    
    private func changePaletteColor(colors: [UIColor]) {
        for i in 0..<colorPaletteButtons.count {
            colorPaletteButtons[i].backgroundColor = colors[i]
        }
    }
    
    private func clearColorPaletteButtons() {
        for button in colorPaletteButtons {
            button.isSelected = false
            button.setImage(nil, for: .normal)
        }
    }
    
    private func changeColorPaletteBasedOnSegment(_ segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            changePaletteColor(colors: [.red, .orange, .yellow, .green, .blue, .purple, .systemPink, .white])
        case 1:
            changePaletteColor(colors: [.black, .brown, .cyan, .darkGray, .darkText, .gray, .label, .lightGray])
        case 2:
            changePaletteColor(colors: [.link, .magenta, .opaqueSeparator, .systemCyan, .systemTeal, .systemMint, .systemIndigo, .clear])
        default:
            break
        }
    }
    
    private func restoreSelectedButton(_ segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == previousSegmentIndex && selectedButton != nil {
            selectedButton?.isSelected = true
            selectedButton?.setImage(UIImage(systemName: "checkmark"), for: .normal)
            selectedButton?.tintColor = .white
        }
    }
    
    private func flowerColorPickerButtonCount(numberOfColors: NumberOfColorsType) {
        switch numberOfColors {
        case .단일:
            flowerColorPickerButton2.isHidden = true
            flowerColorPickerButton3.isHidden = true
        case .두가지, .포인트:
            flowerColorPickerButton2.isHidden = false
            flowerColorPickerButton3.isHidden = true
        case .컬러풀한:
            flowerColorPickerButton2.isHidden = false
            flowerColorPickerButton3.isHidden = false
        }
        configPointColorPickerStyle(numberOfColors)
    }
    
    private func updateOtherColorPaletteButtons(_ sender: UIButton) {
        for button in colorPaletteButtons {
            if button != sender {
                button.setImage(nil, for: .normal)
            }
        }
    }
    
    private func handleColorSelection(_ sender: UIButton) {
        selectedButton = sender
        sender.isSelected = true
        sender.setImage(UIImage(systemName: "checkmark"), for: .normal)
        sender.tintColor = .white
        
        selectedFlowerColorPickerButton.setImage(nil, for: .normal)
        selectedFlowerColorPickerButton.layer.borderColor = .none
        selectedFlowerColorPickerButton.backgroundColor = sender.backgroundColor
        previousSegmentIndex = segmentControl.selectedSegmentIndex
    }
    
    private func resetButtonSelection(_ sender: UIButton) {
        selectedButton = nil
        sender.isSelected = false
        sender.setImage(nil, for: .normal)
        
        selectedFlowerColorPickerButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        selectedFlowerColorPickerButton.layer.borderColor = UIColor.systemMint.cgColor
        selectedFlowerColorPickerButton.backgroundColor = nil
    }
    
    private func updateNextButtonState() {
        var colors: [UIColor?]
        
        switch numberOfColors {
        case .단일:
            if flowerColorPickerButton.backgroundColor != nil {
                colors = [flowerColorPickerButton.backgroundColor]
                viewModel.getColors(colors: colors)
                
                delegate?.isNextButtonEnabled(isEnabled: true)
            } else {
                delegate?.isNextButtonEnabled(isEnabled: false)
            }
        case .두가지, .포인트:
            if flowerColorPickerButton.backgroundColor != nil &&
                flowerColorPickerButton2.backgroundColor != nil {
                colors = [flowerColorPickerButton.backgroundColor, flowerColorPickerButton2.backgroundColor]
                viewModel.getColors(colors: colors)
                
                delegate?.isNextButtonEnabled(isEnabled: true)
            } else {
                delegate?.isNextButtonEnabled(isEnabled: false)
            }
        case .컬러풀한:
            if flowerColorPickerButton.backgroundColor != nil &&
                flowerColorPickerButton2.backgroundColor != nil &&
                flowerColorPickerButton3.backgroundColor != nil {
                colors = [
                    flowerColorPickerButton.backgroundColor,
                    flowerColorPickerButton2.backgroundColor,
                    flowerColorPickerButton3.backgroundColor
                ]
                viewModel.getColors(colors: colors)
                
                delegate?.isNextButtonEnabled(isEnabled: true)
            } else {
                delegate?.isNextButtonEnabled(isEnabled: false)
            }
        }
    }
    
    func configPointColorPickerStyle(_ numberOfColors: NumberOfColorsType) {
        if numberOfColors == .포인트 {
            flowerColorPickerButtonHStackView.distribution = .fill
            
            flowerColorPickerButton.snp.makeConstraints {
                $0.width.equalTo(flowerColorPickerButtonHStackView.snp.width).multipliedBy(0.318).priority(3)
            }
        } else {
            flowerColorPickerButtonHStackView.distribution = .fillEqually
        }
    }
    
    
    // MARK: - Actions
    
    @objc
    func FlowerColorPickerButtonTapped(sender: UIButton) {
        if sender.backgroundColor != nil {
            colorPaletteButtons.forEach {
                if $0.backgroundColor == sender.backgroundColor {
                    selectedButton = $0
                    $0.setImage(UIImage(systemName: "checkmark"), for: .normal)
                    $0.tintColor = .white
                } else {
                    selectedButton = nil
                    $0.setImage(nil, for: .normal)
                }
            }
        }
        updateSelectedFlowerColorPickerButton(with: sender)
        updateOtherFlowerColorPickerButtons()
    }
    
    @objc
    func didChangeValue(segment: UISegmentedControl) {
        clearColorPaletteButtons()
        changeColorPaletteBasedOnSegment(segment)
        restoreSelectedButton(segment)
    }
    
    @objc
    func colorPaletteButtonTapped(_ sender: UIButton) {
        selectedButton != sender ? handleColorSelection(sender) : resetButtonSelection(sender)
        updateOtherColorPaletteButtons(sender)
        updateNextButtonState()
    }
}

extension ColorPickerView {
    private func setupAutoLayout() {
        colorDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        flowerColorPickerButtonHStackView.snp.makeConstraints {
            $0.top.equalTo(colorDescriptionLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(96)
        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(flowerColorPickerButton.snp_bottomMargin).offset(30)
            $0.leading.trailing.equalToSuperview()
        }
        
        colorPaletteVStack.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
