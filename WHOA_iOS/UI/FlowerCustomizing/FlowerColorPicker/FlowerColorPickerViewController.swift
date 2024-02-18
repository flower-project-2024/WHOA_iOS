//
//  FlowerColorPickerViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import UIKit
import SnapKit

class FlowerColorPickerViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: FlowerColorPickerViewModel
    private var isChevronUp = true
    var colorButtonTopConstraint: Constraint?
    
    // MARK: - UI
    
    private let exitButton = ExitButton()
    private let progressHStackView = CustomProgressHStackView(numerator: 2, denominator: 7)
    private let titleLabel = CustomTitleLabel(text: "꽃 조합 색")
    private let descriptionLabel = CustomDescriptionLabel(text: "원하는 느낌의 꽃 조합 색을 선택해주세요", numberOfLines: 1)
    
    private let colorSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = "조합"
        label.font = UIFont(name: "Pretendard", size: 16)
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var colorSelectionHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            colorSelectionLabel,
            chevronImageView
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 9
        stackView.backgroundColor = UIColor(
            red: 249/255,
            green: 249/255,
            blue: 251/255,
            alpha: 1.0
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins =  NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        stackView.addGestureRecognizer(tapGesture)
        return stackView
    }()
    
    private let colorButton1: UIButton = {
        let button = UIButton()
        button.setTitle("단일 색", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.setTitleColor(UIColor(
            red: 102/255,
            green: 102/255,
            blue: 103/255,
            alpha: 1.0
        ), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor(
            red: 233/255,
            green: 233/255,
            blue: 235/255,
            alpha: 1.0
        ).cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorButton2: UIButton = {
        let button = UIButton()
        button.setTitle("2가지 색", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.setTitleColor(UIColor(
            red: 102/255,
            green: 102/255,
            blue: 103/255,
            alpha: 1.0
        ), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor(
            red: 233/255,
            green: 233/255,
            blue: 235/255,
            alpha: 1.0
        ).cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorButton3: UIButton = {
        let button = UIButton()
        button.setTitle("컬러풀한", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.setTitleColor(UIColor(
            red: 102/255,
            green: 102/255,
            blue: 103/255,
            alpha: 1.0
        ), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor(
            red: 233/255,
            green: 233/255,
            blue: 235/255,
            alpha: 1.0
        ).cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorButton4: UIButton = {
        let button = UIButton()
        button.setTitle("포인트 컬러", for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 14)
        button.setTitleColor(UIColor(
            red: 102/255,
            green: 102/255,
            blue: 103/255,
            alpha: 1.0
        ), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor(
            red: 233/255,
            green: 233/255,
            blue: 235/255,
            alpha: 1.0
        ).cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var colorButtonHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            colorButton1,
            colorButton2,
            colorButton3,
            colorButton4,
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.isHidden = true
        return stackView
    }()
    
    private let colorPickerView = ColorPickerView()
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃집마다 가지고 있는 색들이 달라 선택한 색감에 맞는 꽃으로 대체될 수 있습니다."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let backButton = BackButton()
    private let nextButton = NextButton()
    
    private lazy var navigationHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            backButton,
            nextButton
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 9
        return stackView
    }()
    
    // MARK: - Initialize
    
    init(viewModel: FlowerColorPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(exitButton)
        view.addSubview(progressHStackView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(colorSelectionHStackView)
        view.addSubview(colorButtonHStackView)
        view.addSubview(colorPickerView)
        view.addSubview(noticeLabel)
        view.addSubview(navigationHStackView)
        
        setupAutoLayout()
        colorPickerView.isHidden = true
//        self.segCon.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
//        didChangeValue(segment: self.segCon)
    }
    
    // MARK: - Actions
    
    @objc
    func buttonTapped() {
        isChevronUp.toggle()
        chevronImageView.transform = CGAffineTransform(rotationAngle: isChevronUp ? 0 : .pi)
        colorButtonHStackView.isHidden = isChevronUp
        
        colorButtonTopConstraint?.update(offset: isChevronUp ? -21 : 21)
    }
    
    @objc
    func colorButtonTapped(_ sender: UIButton) {
        colorSelectionLabel.text = sender.titleLabel?.text
        colorPickerView.isHidden = false
        
        let buttons = [colorButton1, colorButton2, colorButton3, colorButton4]
        
        sender.layer.borderColor = UIColor(red: 79/255, green: 234/255, blue: 191/255, alpha: 1.0).cgColor
        sender.setTitleColor(.black, for: .normal)
        
        for button in buttons {
            if button != sender {
                button.layer.borderColor = UIColor(
                    red: 233/255,
                    green: 233/255,
                    blue: 235/255,
                    alpha: 1.0
                ).cgColor
                button.setTitleColor(UIColor(
                    red: 102/255,
                    green: 102/255,
                    blue: 103/255,
                    alpha: 1.0
                ), for: .normal)
            }
        }
    }
    
//    @objc
//    func didChangeValue(segment: UISegmentedControl) {
//        lazy var stackViewArray: [UIStackView] = [stackviewA, stackviewB, stackviewC]
//        let selectedIndex = segment.selectedSegmentIndex
//            for (index, stackView) in stackViewArray.enumerated() {
//                stackView.isHidden = index != selectedIndex
//            }
//    }
    
//    @objc
//    func colorPlateButtonTapped(_ sender: UIButton) {
//        realColorButton.setImage(nil, for: .normal)
//        realColorButton.layer.borderColor = .none
//        realColorButton.backgroundColor = sender.backgroundColor
//        
//        sender.setImage(UIImage(systemName: "checkmark"), for: .normal)
//        sender.tintColor = .white
//        
//        let buttons = [
//            colorPlateButton1,
//            colorPlateButton2,
//            colorPlateButton3,
//            colorPlateButton4,
//            colorPlateButton5,
//            colorPlateButton6,
//            colorPlateButton7,
//            colorPlateButton8,
//        ]
//        
//        for button in buttons {
//            if button != sender {
//                button.setImage(nil, for: .normal)
//            }
//        }
        
//    }
}

extension FlowerColorPickerViewController {
    private func setupAutoLayout() {
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.leading.equalToSuperview().offset(17)
        }
        
        progressHStackView.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp_bottomMargin).offset(32)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(18.5)
            $0.height.equalTo(12.75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressHStackView.snp_bottomMargin).offset(24)
            $0.leading.equalTo(view).offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(114)
            $0.width.equalTo(256)
        }
        
        colorSelectionHStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp_bottomMargin).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        colorButtonHStackView.snp.makeConstraints {
            $0.top.equalTo(colorSelectionHStackView.snp_bottomMargin).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        
        colorPickerView.snp.makeConstraints {
            colorButtonTopConstraint = $0.top.equalTo(colorButtonHStackView.snp_bottomMargin).offset(30).constraint
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(56)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(64.125)
            $0.bottom.equalTo(navigationHStackView.snp_topMargin).inset(-20)
        }
        
        navigationHStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-11.5)
        }
    }
}
