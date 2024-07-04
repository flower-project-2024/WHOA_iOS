//
//  FlowerPriceViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 3/10/24.
//

import UIKit

class FlowerPriceViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: FlowerPriceViewModel
    weak var coordinator: CustomizingCoordinator?
    
    // MARK: - UI
    
    private lazy var exitButton = ExitButton(currentVC: self, coordinator: coordinator)
    private let progressHStackView = CustomProgressHStackView(numerator: 5, denominator: 7)
    private let titleLabel = CustomTitleLabel(text: "원하는 가격대 범위를\n설정해주세요")
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "0 ~ 150000원"
        label.font = .Pretendard(size: 20, family: .Bold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let rangeSlider: RangeSlider = {
        let slider = RangeSlider()
        slider.minValue = 0
        slider.maxValue = 150000
        slider.lower = 0
        slider.upper = 150000
        slider.trackColor = .gray2
        slider.trackTintColor = .gray2
        slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        return slider
    }()
    
    private let borderLine = ShadowBorderLine()
    
    private let backButton: BackButton = {
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
    
    init(viewModel: FlowerPriceViewModel) {
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
        
        view.addSubview(exitButton)
        view.addSubview(progressHStackView)
        view.addSubview(titleLabel)
        view.addSubview(valueLabel)
        view.addSubview(rangeSlider)
        
        view.addSubview(borderLine)
        view.addSubview(navigationHStackView)
        
        setupAutoLayout()
    }
    
    private func bind() {
        viewModel.$flowerPriceModel
            .receive(on: RunLoop.main)
            .print()
            .sink { [weak self] model in
                self?.valueLabel.text = self?.viewModel.getPriceString()
            }
            .store(in: &viewModel.cancellables)
    }
    
    // MARK: - Actions
    
    @objc
    private func changeValue() {
        nextButton.isActive = true
        rangeSlider.trackTintColor = .second1
        viewModel.setPrice(min: rangeSlider.lower, max: rangeSlider.upper)
    }
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func nextButtonTapped() {
        coordinator?.showPhotoSelectionVC(price: viewModel.getPriceString())
    }
}

extension FlowerPriceViewController {
    private func setupAutoLayout() {
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(17)
            $0.leading.equalToSuperview().offset(22)
        }
        
        progressHStackView.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).offset(29)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(19.5)
            $0.height.equalTo(12.75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressHStackView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-50)
        }
        
        valueLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(56)
            $0.centerX.equalToSuperview()
        }
        
        rangeSlider.snp.makeConstraints {
            $0.top.equalTo(valueLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(21)
        }
        
        borderLine.snp.makeConstraints {
            $0.top.equalTo(navigationHStackView.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(56)
        }
        
        navigationHStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            $0.leading.trailing.equalToSuperview().inset(18)
        }
    }
}
