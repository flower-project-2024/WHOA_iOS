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
    private lazy var selectedFlowerColorPickerButton: UIButton? = flowerColorPickerButton1
    
    private var flowerColorPickerButtons: [UIButton] = []
    private var colorPaletteButtons: [UIButton] = []
    
    weak var delegate: FlowerColorPickerDelegate?
    
    var numberOfColors: NumberOfColorsType {
        didSet {
            changedNumberOfColors()
            flowerColorPickerButtonCount(numberOfColors: numberOfColors)
            updateNextButtonState()
            viewModel.setNumberOfColors(numberOfColors: numberOfColors)
        }
    }
    
    // MARK: - UI
    
    private let colorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "색을 선택해주세요"
        label.textColor = .black
        label.font = .Pretendard(size: 20, family: .Bold)
        return label
    }()
    
    private let flowerColorPickerButton1: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray02
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.secondary3.cgColor
        button.layer.borderWidth = 2
        button.tag = 1
        button.addTarget(self, action: #selector(FlowerColorPickerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let flowerColorPickerButton2: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray02
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 2
        button.tag = 2
        button.addTarget(self, action: #selector(FlowerColorPickerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let flowerColorPickerButton3: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray02
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 2
        button.tag = 3
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
    
    private let pointLabel: UILabel = {
        let label = UILabel()
        label.text = "포인트컬러"
        label.textColor = .gray07
        label.font = .Pretendard(size: 12, family: .SemiBold)
        label.isHidden = true
        return label
    }()
    
    private let baseLabel: UILabel = {
        let label = UILabel()
        label.text = "베이스컬러"
        label.textColor = .gray07
        label.font = .Pretendard(size: 12, family: .SemiBold)
        label.isHidden = true
        return label
    }()
    
    private let checkCircle1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle")
        imageView.tintColor = .secondary3
        imageView.preferredSymbolConfiguration = .init(pointSize: 24)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let checkCircle2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle")
        imageView.tintColor = .gray05
        imageView.preferredSymbolConfiguration = .init(pointSize: 24)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let checkCircle3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle")
        imageView.tintColor = .gray05
        imageView.preferredSymbolConfiguration = .init(pointSize: 24)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var pointStackview: UIStackView = {
        let stackView = UIStackView()
        [
            pointLabel,
            checkCircle1
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var baseStackview: UIStackView = {
        let stackView = UIStackView()
        [
            baseLabel,
            checkCircle2
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["기본 색감", "진한 색감", "연한 색감"])
        segmentedControl.center = CGPoint(x: self.frame.width/2, y: 400)
        segmentedControl.selectedSegmentIndex = 0
        
        let font = UIFont.Pretendard(family: .SemiBold)
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.gray06,
             NSAttributedString.Key.font: font],
            for: .normal)
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.gray09,
             NSAttributedString.Key.font: font],
            for: .selected)
        segmentedControl.backgroundColor = .gray02
        segmentedControl.selectedSegmentTintColor = .gray01
        return segmentedControl
    }()
    
    private let colorPaletteButton1: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPaletteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPaletteButton2: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPaletteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPaletteButton3: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPaletteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPaletteButton4: UIButton = {
        let button = UIButton()
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
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPaletteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPaletteButton6: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPaletteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPaletteButton7: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPaletteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPaletteButton8: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray04.cgColor
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
        addSubview(pointStackview)
        addSubview(baseStackview)
        addSubview(checkCircle3)
        addSubview(segmentControl)
        addSubview(colorPaletteVStack)
        
        setupAutoLayout()
        setupSegmentControl()
    }
    
    private func changedNumberOfColors() {
        clearFlowerColorPickerButtons()
        clearColorPaletteButtons()
        deleteColors()
        
        selectedFlowerColorPickerButton = nil
        selectedButton = nil
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
            flowerColorPickerButton1,
            flowerColorPickerButton2,
            flowerColorPickerButton3
        ]
    }
    
    private func deleteColors() {
        flowerColorPickerButtons.forEach { $0.backgroundColor = .gray02 }
    }
    
    // 도화지 클릭 시 해당 도화지가 이미 선택된 도화지가 아니면 UI(체크마크, 테두리색)를 변경해주는 메서드
    private func updateSelectedFlowerColorPickerButton(with selectedButton: UIButton) {
        selectedButton.layer.borderColor = UIColor.secondary3.cgColor
        
        switch selectedButton.tag {
        case 1:
            checkCircle1.tintColor = .secondary3
        case 2:
            checkCircle2.tintColor = .secondary3
        case 3:
            checkCircle3.tintColor = .secondary3
        default:
            break
        }
    }
    
    private func clearFlowerColorPickerButtons() {
        flowerColorPickerButtons.forEach { $0.layer.borderColor = UIColor.clear.cgColor }
        [checkCircle1, checkCircle2, checkCircle3].forEach { $0.tintColor = .gray05 }
    }
    
    func updatePaletteButtonCheckImage(with sender: UIButton?) {
        guard let backgroundColor = sender?.backgroundColor else {
            return
        }
        
        let btnColor = self.segmentControl.selectedSegmentIndex == 1 ? UIColor.gray01.withAlphaComponent(0.5) : UIColor.paletteCheckButton
        
        colorPaletteButtons.forEach {
            if $0.backgroundColor == backgroundColor {
                let colorsConfig = UIImage.SymbolConfiguration(paletteColors: [.gray01, btnColor, btnColor])
                $0.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: colorsConfig), for: .normal)
                selectedButton = $0
            } else {
                selectedButton = nil
                $0.setImage(nil, for: .normal)
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
            changePaletteColor(colors: [.default1, .default2, .default3, .default4, .default5, .default6, .default7, .default8])
        case 1:
            changePaletteColor(colors: [.dark1, .dark2, .dark3, .dark4, .dark5, .dark6, .dark7, .dark8])
        case 2:
            changePaletteColor(colors: [.light1, .light2, .light3, .light4, .light5, .light6, .light7, .light8])
        default:
            break
        }
    }
    
    private func restoreSelectedButton(_ segment: UISegmentedControl) {
        if selectedButton != nil {
            let colorsConfig = UIImage.SymbolConfiguration(paletteColors: [.gray01, .paletteCheckButton, .paletteCheckButton])
            selectedButton?.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: colorsConfig), for: .normal)
            selectedButton?.isSelected = true
        }
    }
    
    private func flowerColorPickerButtonCount(numberOfColors: NumberOfColorsType) {
        pointLabel.isHidden = true
        baseLabel.isHidden = true
        
        switch numberOfColors {
        case .oneColor:
            flowerColorPickerButton2.isHidden = true
            flowerColorPickerButton3.isHidden = true
            checkCircle2.isHidden = true
            checkCircle3.isHidden = true
        case .twoColor:
            flowerColorPickerButton2.isHidden = false
            flowerColorPickerButton3.isHidden = true
            checkCircle2.isHidden = false
            checkCircle3.isHidden = true
        case .colorful:
            flowerColorPickerButton2.isHidden = false
            flowerColorPickerButton3.isHidden = false
            checkCircle2.isHidden = false
            checkCircle3.isHidden = false
        case .pointColor:
            flowerColorPickerButton2.isHidden = false
            flowerColorPickerButton3.isHidden = true
            checkCircle2.isHidden = false
            checkCircle3.isHidden = true
            pointLabel.isHidden = false
            baseLabel.isHidden = false
        }
        configPointColorPickerStyle(numberOfColors)
    }
    
    private func updateOtherColorPaletteButtons(_ sender: UIButton) {
        for button in colorPaletteButtons {
            if button != sender {
                button.setImage(nil, for: .normal)
                button.isSelected = false
            }
        }
    }
    
    private func handleColorSelection(_ sender: UIButton) {
        selectedButton = sender
        sender.isSelected = true
        
        let btnColor = self.segmentControl.selectedSegmentIndex == 1 ? UIColor.gray01.withAlphaComponent(0.5) : UIColor.paletteCheckButton
        let colorsConfig = UIImage.SymbolConfiguration(paletteColors: [.gray01, btnColor, btnColor])
        sender.setImage(UIImage(systemName: "checkmark.circle.fill", withConfiguration: colorsConfig), for: .normal)
        
        selectedFlowerColorPickerButton?.backgroundColor = sender.backgroundColor
    }
    
    private func updateNextButtonState() {
        var colors: [String]
        
        switch numberOfColors {
        case .oneColor:
            if flowerColorPickerButton1.backgroundColor != .gray02 {
                colors = [flowerColorPickerButton1.backgroundColor].compactMap { $0?.toHexString() }
                viewModel.setColors(colors: colors)
                
                delegate?.isNextButtonEnabled(isEnabled: true)
            } else {
                delegate?.isNextButtonEnabled(isEnabled: false)
            }
        case .twoColor, .pointColor:
            if flowerColorPickerButton1.backgroundColor != .gray02 &&
                flowerColorPickerButton2.backgroundColor != .gray02 {
                colors = [flowerColorPickerButton1.backgroundColor, flowerColorPickerButton2.backgroundColor].compactMap { $0?.toHexString() }
                viewModel.setColors(colors: colors)
                
                delegate?.isNextButtonEnabled(isEnabled: true)
            } else {
                delegate?.isNextButtonEnabled(isEnabled: false)
            }
        case .colorful:
            if flowerColorPickerButton1.backgroundColor != .gray02 &&
                flowerColorPickerButton2.backgroundColor != .gray02 &&
                flowerColorPickerButton3.backgroundColor != .gray02 {
                colors = [
                    flowerColorPickerButton1.backgroundColor,
                    flowerColorPickerButton2.backgroundColor,
                    flowerColorPickerButton3.backgroundColor
                ].compactMap { $0?.toHexString() }
                viewModel.setColors(colors: colors)
                
                delegate?.isNextButtonEnabled(isEnabled: true)
            } else {
                delegate?.isNextButtonEnabled(isEnabled: false)
            }
        }
    }
    
    func configPointColorPickerStyle(_ numberOfColors: NumberOfColorsType) {
        if numberOfColors == .pointColor {
            flowerColorPickerButtonHStackView.distribution = .fill
            
            flowerColorPickerButton1.snp.makeConstraints {
                $0.width.equalTo(flowerColorPickerButtonHStackView.snp.width).multipliedBy(0.318).priority(3)
            }
        } else {
            flowerColorPickerButtonHStackView.distribution = .fillEqually
        }
    }
    
    // MARK: - Actions
    
    @objc
    func FlowerColorPickerButtonTapped(sender: UIButton) {
        selectedFlowerColorPickerButton = sender
        
        clearFlowerColorPickerButtons()
        updateSelectedFlowerColorPickerButton(with: sender)
        updatePaletteButtonCheckImage(with: sender)
    }
    
    @objc
    func didChangeValue(segment: UISegmentedControl) {
        clearColorPaletteButtons()
        changeColorPaletteBasedOnSegment(segment)
        restoreSelectedButton(segment)
        updatePaletteButtonCheckImage(with: self.selectedFlowerColorPickerButton)
    }
    
    @objc
    func colorPaletteButtonTapped(_ sender: UIButton) {
        guard selectedFlowerColorPickerButton != nil else { return }
        
        handleColorSelection(sender)
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
        
        pointStackview.snp.makeConstraints {
            $0.centerX.equalTo(flowerColorPickerButton1.snp.centerX)
            $0.top.equalTo(flowerColorPickerButton1.snp.bottom).offset(4)
        }
        
        baseStackview.snp.makeConstraints {
            $0.centerX.equalTo(flowerColorPickerButton2.snp.centerX)
            $0.top.equalTo(flowerColorPickerButton1.snp.bottom).offset(4)
        }
        
        checkCircle3.snp.makeConstraints {
            $0.centerX.equalTo(flowerColorPickerButton3.snp.centerX)
            $0.top.equalTo(flowerColorPickerButton1.snp.bottom).offset(4)
        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(checkCircle1.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        colorPaletteButton1.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        colorPaletteVStack.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
