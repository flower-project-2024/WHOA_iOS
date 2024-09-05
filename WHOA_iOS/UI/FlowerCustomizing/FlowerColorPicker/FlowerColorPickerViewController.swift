//
//  FlowerColorPickerViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import UIKit
import SnapKit

final class FlowerColorPickerViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: FlowerColorPickerViewModel
    weak var coordinator: CustomizingCoordinator?
    
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
    
    private lazy var exitButton = ExitButton(currentVC: self, coordinator: coordinator)
    private let progressHStackView = CustomProgressHStackView(numerator: 2, denominator: 7)
    private let titleLabel = CustomTitleLabel(text: "꽃 조합 색")
    private let descriptionLabel = CustomDescriptionLabel(text: "원하는 느낌의 꽃 조합 색을 선택해주세요", numberOfLines: 1)
    
    private let numberOfColorsBox = NumberOfColorsBox()
    
    private let singleColorButton: UIButton = {
        let button = ColorSelectionButton(.oneColor)
        button.addTarget(self, action: #selector(numberOfColorsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let dualColorButton: UIButton = {
        let button = ColorSelectionButton(.twoColor)
        button.addTarget(self, action: #selector(numberOfColorsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let colorfulButton: UIButton = {
        let button = ColorSelectionButton(.colorful)
        button.addTarget(self, action: #selector(numberOfColorsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let pointColorButton: UIButton = {
        let button = ColorSelectionButton(.pointColor)
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
        view.backgroundColor = .gray02
        return view
    }()
    
    private lazy var colorPickerView: ColorPickerView = {
        let view = ColorPickerView(viewModel: viewModel, numberOfColors: .oneColor)
        view.isHidden = true
        return view
    }()
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃집마다 가지고 있는 색들이 달라\n선택한 색감에 맞는 꽃으로 대체될 수 있습니다."
        label.font = .Pretendard(size: 12, family: .Regular)
        label.textColor = .gray07
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let borderLine = ShadowBorderLine()
    
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
        
        bind()
        setupUI()
        colorPickerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        extendedLayoutIncludesOpaqueBars = false
        navigationController?.setNavigationBarHidden(false, animated: false)
        tabBarController?.tabBar.isHidden = false
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
        
        scrollContentView.addSubview(numberOfColorsBox)
        scrollContentView.addSubview(colorPickerBorderLine)
        scrollContentView.addSubview(numberOfColorsButtonHStackView)
        scrollContentView.addSubview(colorPickerView)
        
        scrollContentView.addSubview(noticeLabel)
        view.addSubview(borderLine)
        view.addSubview(navigationHStackView)
        
        setupAutoLayout()
        addTapGesture()
    }
    
    private func bind() {
        viewModel.$iscolorSelectionHidden
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isHidden in
                self?.numberOfColorsBox.chevronImageView.transform = CGAffineTransform(rotationAngle: isHidden ? 0 : .pi)
                self?.numberOfColorsButtonHStackView.isHidden = isHidden
                self?.updateColorPickerBorderLineConstraints(isHidden: isHidden)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(numberOfColorsBoxTapped))
        numberOfColorsBox.addGestureRecognizer(tapGesture)
    }
    
    private func updateButtonSelection(with selectedButton: ColorSelectionButton) {
        let buttons = [singleColorButton, dualColorButton, colorfulButton, pointColorButton]
        buttons.forEach { ($0 as? ColorSelectionButton)?.isActive = $0 == selectedButton ? true : false }
    }
    
    private func updateColorPickerBorderLineConstraints(isHidden: Bool) {
        colorPickerBorderLine.snp.remakeConstraints {
            if isHidden {
                $0.top.equalTo(numberOfColorsBox.snp.bottom).offset(24)
            } else {
                $0.top.equalTo(numberOfColorsButtonHStackView.snp.bottom).offset(44)
            }
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    private func updateNoticeLabelConstraints() {
        noticeLabel.snp.remakeConstraints {
            $0.top.equalTo(colorPickerView.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(scrollContentView.snp.bottom).offset(-12)
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func numberOfColorsBoxTapped() {
        viewModel.iscolorSelectionHidden.toggle()
    }
    
    @objc
    func numberOfColorsButtonTapped(_ sender: ColorSelectionButton) {
        self.numberOfColorsBox.colorSelectionLabel.text = sender.titleLabel?.text
        colorPickerView.numberOfColors = NumberOfColorsType(rawValue: sender.titleLabel?.text ?? "") ?? .oneColor
        colorPickerView.isHidden = false
        
        updateNoticeLabelConstraints()
        updateButtonSelection(with: sender)
    }
    
    @objc
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func nextButtonTapped() {
        let numberOfColors = viewModel.getNumberOfColors()
        var colors: [String] = viewModel.getColors()
        var pointColor: String?
        
        if numberOfColors == .pointColor {
            pointColor = colors.removeFirst()
        }
        
        let colorScheme = BouquetData.ColorScheme(numberOfColors: numberOfColors, pointColor: pointColor, colors: colors)
        
        viewModel.dataManager.setColorScheme(colorScheme)
        coordinator?.showFlowerSelectionVC()
    }
}

extension FlowerColorPickerViewController {
    private func setupAutoLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(borderLine.snp.top)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
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
        
        numberOfColorsBox.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        numberOfColorsButtonHStackView.snp.makeConstraints {
            $0.top.equalTo(numberOfColorsBox.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        
        colorPickerBorderLine.snp.makeConstraints {
            $0.top.equalTo(numberOfColorsButtonHStackView.snp.bottom).offset(44)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        colorPickerView.snp.makeConstraints {
            $0.top.equalTo(colorPickerBorderLine.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(colorPickerView.snp.bottom).offset(-17)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(scrollContentView.snp.bottom).offset(-12)
        }
        
        borderLine.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(56)
        }
        
        navigationHStackView.snp.makeConstraints {
            $0.top.equalTo(borderLine.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-18)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
    }
}

extension FlowerColorPickerViewController: FlowerColorPickerDelegate {
    func isNextButtonEnabled(isEnabled: Bool) {
        nextButton.isActive = isEnabled
    }
}
