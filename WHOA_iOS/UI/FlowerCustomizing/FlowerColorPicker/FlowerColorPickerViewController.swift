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
    
    var shouldHideFirstView: Bool? {
        didSet {
            guard let shouldHideFirstView = self.shouldHideFirstView else { return }
            self.stackviewA.isHidden = shouldHideFirstView
            self.stackviewB.isHidden = !self.stackviewA.isHidden
        }
    }
    
    // MARK: - UI
    
    private let exitButton = ExitButton()
    private let progressHStackView = CustomProgressHStackView(numerator: 2, denominator: 7)
    private let titleLabel = CustomTitleLabel(text: "꽃 조합 색")
    private let descriptionLabel = CustomDescriptionLabel(text: "원하는 느낌의 꽃 조합 색을 선택해주세요", numberOfLines: 1)
    
    private let colorSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = "조합"
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
        stackView.backgroundColor = .systemGray5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins =  NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        stackView.addGestureRecognizer(tapGesture)
        return stackView
    }()
    
    private let colorButton1: UIButton = {
        let button = UIButton()
        button.setTitle("단일 색", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorButton2: UIButton = {
        let button = UIButton()
        button.setTitle("2가지 색", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorButton3: UIButton = {
        let button = UIButton()
        button.setTitle("컬러풀한", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorButton4: UIButton = {
        let button = UIButton()
        button.setTitle("포인트 컬러", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        button.layer.borderColor = UIColor.lightGray.cgColor
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
    
    private let colorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "색을 선택해주세요"
        return label
    }()
    
    private let realColorButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.systemMint.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    lazy var segCon: UISegmentedControl = {
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["기본 색감", "진한 색감", "연한 색감"])
        segmentedControl.center = CGPoint(x: self.view.frame.width/2, y: 400)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    let stackviewA: UIStackView = {
        // UIStackView 및 UIButton 생성
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        let basicColors = [UIColor.red, .orange, .yellow, .green, .blue, .purple, .purple, .cyan]
        for color in basicColors {
            let button = UIButton()
            button.backgroundColor = color
            stackView.addArrangedSubview(button)
        }
        
        return stackView
    }()
    
    let stackviewB: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        let basicColors = [UIColor.red, .red, .red, .red, .red, .red, .red, .red]
        for color in basicColors {
            let button = UIButton()
            button.backgroundColor = color
            stackView.addArrangedSubview(button)
        }
        
        return stackView
    }()
    
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
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(exitButton)
        view.addSubview(progressHStackView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(colorSelectionHStackView)
        view.addSubview(colorButtonHStackView)
        view.addSubview(colorDescriptionLabel)
        view.addSubview(realColorButton)
        view.addSubview(segCon)
        view.addSubview(stackviewA)
        view.addSubview(stackviewB)
        view.addSubview(noticeLabel)
        view.addSubview(navigationHStackView)
        
        setupAutoLayout()
        colorDescriptionLabel.isHidden = true
        realColorButton.isHidden = true
        segCon.isHidden = true
        self.segCon.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        didChangeValue(segment: self.segCon)
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
        colorDescriptionLabel.isHidden = false
        realColorButton.isHidden = false
        segCon.isHidden = false
    }
    
    @objc 
    func didChangeValue(segment: UISegmentedControl) {
      self.shouldHideFirstView = segment.selectedSegmentIndex != 0
    }
    
}

extension FlowerColorPickerViewController {
    private func setupAutoLayout() {
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(2)
            $0.leading.equalToSuperview().offset(12.75)
        }
        
        progressHStackView.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp_bottomMargin).offset(15.375)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(13.875)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-13.125)
            $0.height.equalTo(12.75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressHStackView.snp_bottomMargin).offset(16.875)
            $0.leading.equalTo(view).offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(32)
            $0.leading.equalTo(view).offset(20)
            $0.width.equalTo(250)
        }
        
        colorSelectionHStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel).offset(36)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(56)
        }
        
        colorButtonHStackView.snp.makeConstraints {
            $0.top.equalTo(colorSelectionHStackView.snp_bottomMargin).offset(21)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        
        colorDescriptionLabel.snp.makeConstraints {
            colorButtonTopConstraint = $0.top.equalTo(colorButtonHStackView.snp_bottomMargin).offset(30).constraint
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        
        realColorButton.snp.makeConstraints {
            $0.top.equalTo(colorDescriptionLabel.snp_bottomMargin).offset(30)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(96)
        }
        
        segCon.snp.makeConstraints {
            $0.top.equalTo(realColorButton.snp_bottomMargin).offset(30)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        
        stackviewA.snp.makeConstraints {
            $0.top.equalTo(segCon.snp_bottomMargin).offset(40)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        
        stackviewB.snp.makeConstraints {
            $0.top.equalTo(segCon.snp_bottomMargin).offset(40)
            $0.leading.trailing.equalToSuperview().inset(15)
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
