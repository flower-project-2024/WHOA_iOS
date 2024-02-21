//
//  ColorPickerView.swift
//  WHOA_iOS
//
//  Created by KSH on 2/18/24.
//

import UIKit

class ColorPickerView: UIView {
    
    private var selectedColor: UIColor?
    private var selectedButton: UIButton?
    private var colorPlateButtons: [UIButton] = []
    private var previousSegmentIndex: Int = 0
    
    var numberOfColors: NumberOfColorsType {
        didSet {
            updateRealColorButtons(numberOfColors: numberOfColors)
        }
    }
    
    // MARK: - Properties
    
    private let colorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "색을 선택해주세요"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        return label
    }()
    
    private let flowerColorPickerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.setTitle("1", for: .normal)
        button.tintColor = UIColor.systemMint
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.systemMint.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(realColorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let flowerColorPickerButton2: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.app"), for: .normal)
        button.setTitle("2", for: .normal)
        button.tintColor = UIColor.lightGray
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(realColorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let flowerColorPickerButton3: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.app"), for: .normal)
        button.setTitle("3", for: .normal)
        button.tintColor = UIColor.lightGray
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(realColorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var flowerColorPickerButtonHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(flowerColorPickerButton)
        flowerColorPickerButtonCount(numberOfColors: numberOfColors).forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    
    lazy var segmentContrl: UISegmentedControl = {
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["기본 색감", "진한 색감", "연한 색감"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.center = CGPoint(x: self.frame.width/2, y: 400)
        return segmentedControl
    }()
    
    private let colorPlateButton1: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPlateButton2: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPlateButton3: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPlateButton4: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var colorPlateHStack = {
        let stackView = UIStackView()
        [
            colorPlateButton1,
            colorPlateButton2,
            colorPlateButton3,
            colorPlateButton4,
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let colorPlateButton5: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPlateButton6: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPlateButton7: UIButton = {
        let button = UIButton()
        button.backgroundColor = .purple
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPlateButton8: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var colorPlateHStack2 = {
        let stackView = UIStackView()
        [
            colorPlateButton5,
            colorPlateButton6,
            colorPlateButton7,
            colorPlateButton8,
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var colorPlateVStack: UIStackView = {
        let stackView = UIStackView()
        [
            colorPlateHStack,
            colorPlateHStack2
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Initialize
    
    init(numberOfColors: NumberOfColorsType) {
        self.numberOfColors = numberOfColors
        super.init(frame: .zero)
        
        colorPlateButtons = [
            colorPlateButton1,
            colorPlateButton2,
            colorPlateButton3,
            colorPlateButton4,
            colorPlateButton5,
            colorPlateButton6,
            colorPlateButton7,
            colorPlateButton8
        ]
        
        setupUI()
        self.segmentContrl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        didChangeValue(segment: self.segmentContrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        addSubview(colorDescriptionLabel)
        addSubview(flowerColorPickerButtonHStackView)
        addSubview(segmentContrl)
        addSubview(colorPlateVStack)
        
        setupAutoLayout()
    }
    
    private func changePlateColor(colors: [UIColor]) {
        for i in 0..<colorPlateButtons.count {
            colorPlateButtons[i].backgroundColor = colors[i]
        }
    }
    
    private func flowerColorPickerButtonCount(numberOfColors: NumberOfColorsType) -> [UIButton] {
        var buttons = [UIButton]()
        
        switch numberOfColors {
        case .단일:
            break
        case .두가지, .포인트:
            buttons = [flowerColorPickerButton2]
        case .컬러풀한:
            buttons = [flowerColorPickerButton2, flowerColorPickerButton3]
        }
        
        return buttons
    }
    
    private func updateRealColorButtons(numberOfColors: NumberOfColorsType) {
        flowerColorPickerButtonHStackView.arrangedSubviews.forEach {
            if $0 != flowerColorPickerButton {
                flowerColorPickerButtonHStackView.removeArrangedSubview($0)
                $0.isHidden = true
            }
        }
        
        flowerColorPickerButtonCount(numberOfColors: numberOfColors).forEach {
            flowerColorPickerButtonHStackView.addArrangedSubview($0)
            $0.isHidden = false
        }
    }
    
    // MARK: - Actions
    
    @objc
    func realColorButtonTapped(sender: UIButton) {
        print(sender.titleLabel?.text)
    }
    
    @objc
    func didChangeValue(segment: UISegmentedControl) {
        
        for button in colorPlateButtons {
            button.isSelected = false
            button.setImage(nil, for: .normal)
        }
        
        switch segment.selectedSegmentIndex {
        case 0:
            changePlateColor(colors: [.red,.orange,.yellow,.green,.blue,.purple,.systemPink,.white])
        case 1:
            changePlateColor(colors: [.black, .brown, .cyan,.darkGray, .darkText, .gray, .label, .lightGray])
        case 2:
            changePlateColor(colors:      [.link,.magenta,.opaqueSeparator,.systemCyan,.systemTeal,.systemMint,.systemIndigo,.clear])
        default:
            break
        }
        
        if segment.selectedSegmentIndex == previousSegmentIndex && selectedButton != nil {
            selectedButton?.isSelected = true
            selectedButton?.setImage(UIImage(systemName: "checkmark"), for: .normal)
            selectedButton?.tintColor = .white
        }
        
    }
    
    @objc
    func colorPlateButtonTapped(_ sender: UIButton) {
        
        if selectedButton != sender {
            selectedButton = sender
            sender.isSelected = true
            sender.setImage(UIImage(systemName: "checkmark"), for: .normal)
            sender.tintColor = .white
            
            flowerColorPickerButton.setImage(nil, for: .normal)
            flowerColorPickerButton.layer.borderColor = .none
            flowerColorPickerButton.backgroundColor = sender.backgroundColor
            previousSegmentIndex = segmentContrl.selectedSegmentIndex
        } else {
            selectedButton = nil
            sender.isSelected = false
            sender.setImage(nil, for: .normal)
            
            flowerColorPickerButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            flowerColorPickerButton.layer.borderColor = UIColor.systemMint.cgColor
            flowerColorPickerButton.backgroundColor = .clear
        }
        
        for button in colorPlateButtons {
            if button != sender {
                button.setImage(nil, for: .normal)
            }
        }
    }
}

extension ColorPickerView {
    private func setupAutoLayout() {
        colorDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        flowerColorPickerButtonHStackView.snp.makeConstraints {
            $0.top.equalTo(colorDescriptionLabel.snp_bottomMargin).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(96)
        }
        
        segmentContrl.snp.makeConstraints {
            $0.top.equalTo(flowerColorPickerButton.snp_bottomMargin).offset(30)
            $0.leading.trailing.equalToSuperview()
        }
        
        colorPlateVStack.snp.makeConstraints {
            $0.top.equalTo(segmentContrl.snp_bottomMargin).offset(40)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
