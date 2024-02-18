//
//  ColorPickerView.swift
//  WHOA_iOS
//
//  Created by KSH on 2/18/24.
//

import UIKit

class ColorPickerView: UIView {
    
    // MARK: - Properties
    
    private let colorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "색을 선택해주세요"
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        return label
    }()
    
    private let realColorButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = UIColor.systemMint
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.systemMint.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    lazy var segCon: UISegmentedControl = {
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
//        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPlateButton2: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPlateButton3: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPlateButton4: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
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
//        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPlateButton6: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPlateButton7: UIButton = {
        let button = UIButton()
        button.backgroundColor = .purple
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorPlateButton8: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
//        button.addTarget(self, action: #selector(colorPlateButtonTapped), for: .touchUpInside)
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
    
    private lazy var stackviewA: UIStackView = {
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
    
//    private lazy var stackviewB: UIStackView = {
//        let stackView = UIStackView()
//        stackView.backgroundColor = .red
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.spacing = 8
//        return stackView
//    }()
//    
//    private lazy var stackviewC: UIStackView = {
//        let stackView = UIStackView()
//        stackView.backgroundColor = .green
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.spacing = 8
//        return stackView
//    }()
    
    // MARK: - Initialize
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        addSubview(colorDescriptionLabel)
        addSubview(realColorButton)
        addSubview(segCon)
        addSubview(stackviewA)
//        addSubview(stackviewB)
//        addSubview(stackviewC)
        
        setupAutoLayout()
    }
}



extension ColorPickerView {
    private func setupAutoLayout() {
        colorDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        realColorButton.snp.makeConstraints {
            $0.top.equalTo(colorDescriptionLabel.snp_bottomMargin).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(96)
        }
        
        segCon.snp.makeConstraints {
            $0.top.equalTo(realColorButton.snp_bottomMargin).offset(30)
            $0.leading.trailing.equalToSuperview()
        }
        
        stackviewA.snp.makeConstraints {
            $0.top.equalTo(segCon.snp_bottomMargin).offset(40)
            $0.leading.trailing.equalToSuperview()
        }
        
//        stackviewB.snp.makeConstraints {
//            $0.top.equalTo(stackviewA)
//            $0.leading.trailing.equalToSuperview().inset(15)
//            $0.height.equalTo(segCon)
//            $0.width.equalTo(segCon)
//        }
//        
//        stackviewC.snp.makeConstraints {
//            $0.top.equalTo(stackviewA)
//            $0.leading.trailing.equalToSuperview().inset(15)
//            $0.height.equalTo(segCon)
//            $0.width.equalTo(segCon)
//        }

    }
}
