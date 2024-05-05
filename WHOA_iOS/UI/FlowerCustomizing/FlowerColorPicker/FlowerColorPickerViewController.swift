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
    
    private let viewModel: FlowerColorPickerViewModel
    private var colorButtonTopConstraint: Constraint?
    private var isChevronUp = true
    
    // MARK: - UI
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let exitButton = ExitButton()
    private let progressHStackView = CustomProgressHStackView(numerator: 2, denominator: 7)
    private let titleLabel = CustomTitleLabel(text: "꽃 조합 색")
    private let descriptionLabel = CustomDescriptionLabel(text: "원하는 느낌의 꽃 조합 색을 선택해주세요", numberOfLines: 1)
    
    private let colorSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = "조합"
        label.textColor = .gray9
        label.font = UIFont.Pretendard(size: 16, family: .SemiBold)
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
        ].forEach { stackView.addArrangedSubview($0) }
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 9
        stackView.backgroundColor = .gray2
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins =  NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorSelectionHStackViewTapped))
        stackView.addGestureRecognizer(tapGesture)
        return stackView
    }()
    
    private let singleColorButton: UIButton = {
        let button = ColorSelectionButton(.단일)
        button.addTarget(self, action: #selector(numberOfColorsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let dualColorButton: UIButton = {
        let button = ColorSelectionButton(.두가지)
        button.addTarget(self, action: #selector(numberOfColorsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorfulButton: UIButton = {
        let button = ColorSelectionButton(.컬러풀한)
        button.addTarget(self, action: #selector(numberOfColorsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let pointColorButton: UIButton = {
        let button = ColorSelectionButton(.포인트)
        button.addTarget(self, action: #selector(numberOfColorsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var numberOfColorsButtonHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            singleColorButton,
            dualColorButton,
            colorfulButton,
            pointColorButton,
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.isHidden = true
        return stackView
    }()
    
    private let colorPickerBorderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    
    private lazy var colorPickerView = ColorPickerView(viewModel: viewModel, numberOfColors: .단일)
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃집마다 가지고 있는 색들이 달라\n선택한 색감에 맞는 꽃으로 대체될 수 있습니다."
        label.font = .Pretendard(size: 12, family: .Regular)
        label.textColor = .gray7
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let borderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    
    private let backButton: UIButton = {
        let button = BackButton(isActive: true)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: NextButton = {
        let button = NextButton()
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
        colorPickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        colorPickerView.isHidden = true
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(scrollContentView)
        
        scrollContentView.addSubview(exitButton)
        scrollContentView.addSubview(progressHStackView)
        scrollContentView.addSubview(titleLabel)
        scrollContentView.addSubview(descriptionLabel)
        
        scrollContentView.addSubview(colorSelectionHStackView)
        scrollContentView.addSubview(colorPickerBorderLine)
        scrollContentView.addSubview(numberOfColorsButtonHStackView)
        scrollContentView.addSubview(colorPickerView)
        
        scrollContentView.addSubview(noticeLabel)
        scrollContentView.addSubview(borderLine)
        scrollContentView.addSubview(navigationHStackView)
        
        setupAutoLayout()
    }
    
    private func updateButtonSelection(with selectedButton: ColorSelectionButton) {
        let buttons = [singleColorButton, dualColorButton, colorfulButton, pointColorButton]
        buttons.forEach { ($0 as? ColorSelectionButton)?.isActive = $0 == selectedButton ? true : false }
    }
    
    // MARK: - Actions
    
    @objc
    func colorSelectionHStackViewTapped() {
        isChevronUp.toggle()
        chevronImageView.transform = CGAffineTransform(rotationAngle: isChevronUp ? 0 : .pi)
        colorButtonTopConstraint?.update(offset: isChevronUp ? 24 : 100)
        numberOfColorsButtonHStackView.isHidden = isChevronUp
    }
    
    @objc
    func numberOfColorsButtonTapped(_ sender: ColorSelectionButton) {
        colorSelectionLabel.text = sender.titleLabel?.text
        colorPickerView.numberOfColors = NumberOfColorsType(rawValue: sender.titleLabel?.text ?? "") ?? .단일
        colorPickerView.isHidden = false
        
        updateButtonSelection(with: sender)
    }
    
    @objc
    func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    func nextButtonTapped() {
        viewModel.goToNextVC(fromCurrentVC: self, animated: true)
    }
}

extension FlowerColorPickerViewController {
    private func setupAutoLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-4)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(880)
        }
        
        exitButton.snp.makeConstraints {
            $0.top.equalTo(scrollContentView.snp.top).offset(17)
            $0.leading.equalToSuperview().offset(17)
        }
        
        progressHStackView.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).offset(29)
            $0.leading.trailing.equalToSuperview().inset(19.5)
            $0.height.equalTo(12.75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressHStackView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
        }
        
        colorSelectionHStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        numberOfColorsButtonHStackView.snp.makeConstraints {
            $0.top.equalTo(colorSelectionHStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        
        colorPickerBorderLine.snp.makeConstraints {
            colorButtonTopConstraint = $0.top.equalTo(colorSelectionHStackView.snp.bottom).offset(24).constraint
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        colorPickerView.snp.makeConstraints {
            $0.top.equalTo(colorPickerBorderLine.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(340)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(colorPickerView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        borderLine.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(3)
        }
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(56)
        }
        
        navigationHStackView.snp.makeConstraints {
            $0.top.equalTo(borderLine.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-11.5)
        }
    }
}

extension FlowerColorPickerViewController: FlowerColorPickerDelegate {
    func isNextButtonEnabled(isEnabled: Bool) {
        nextButton.isActive = isEnabled
    }
}
