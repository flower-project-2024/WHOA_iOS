//
//  FlowerPriceViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 3/10/24.
//

import UIKit

class FlowerPriceViewController: UIViewController {
    
    // MARK: - Initialize
    
    // MARK: - UI
    
    private let exitButton = ExitButton()
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
    
    private let borderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    
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
        view.addSubview(valueLabel)
        view.addSubview(rangeSlider)
        
        view.addSubview(borderLine)
        view.addSubview(navigationHStackView)
        
        setupAutoLayout()
    }
    
    private func bind() {
        
    }
    
    // MARK: - Actions
    
    @objc
    private func changeValue() {
        nextButton.isActive = true
        rangeSlider.trackTintColor = .second1
        
        let maxNumber = self.rangeSlider.upper
        let minNumber = self.rangeSlider.lower
        
        let roundedmaxNumber = Int(floor(Double(maxNumber) / 1000.0) * 1000)
        let roundedminNumber = Int(floor(Double(minNumber) / 1000.0) * 1000)
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        guard let formattedMaxNumber = formatter.string(from: NSNumber(value: roundedmaxNumber / 1000 * 1000)) else { return }
        guard let formattedMinNumber = formatter.string(from: NSNumber(value: roundedminNumber / 1000 * 1000)) else { return }
        
        self.valueLabel.text = "\(formattedMinNumber) ~ \(formattedMaxNumber)원"
      }
    
    @objc
    private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func nextButtonTapped() {
        print("다음이동")
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
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(21)
        }
        
        borderLine.snp.makeConstraints {
            $0.top.equalTo(navigationHStackView.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(3)
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
