//
//  FlowerPriceViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 3/10/24.
//

import UIKit

final class FlowerPriceViewController: UIViewController {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let sideMargin = 20.0
        static let requestDetailViewTopOffset = 37.0
        static let bottomViewTopOffset = 22.0
    }
    
    /// Attributes
    private enum Attributes {
        static let headerViewTitle = "원하는 가격대 범위를\n설정해주세요"
        static let minPrice: Double = 0
        static let maxPrice: Double = 150000
        static let valueLabelText = "\(minPrice) ~ \(maxPrice)원"
    }
    
    // MARK: - Properties
    
    private let viewModel: FlowerPriceViewModel
    weak var coordinator: CustomizingCoordinator?
    
    // MARK: - UI
    
    private lazy var headerView = CustomHeaderView(
        currentVC: self,
        coordinator: coordinator,
        numerator: 5,
        title: Attributes.headerViewTitle
    )
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.text = Attributes.valueLabelText
        label.font = .Pretendard(size: 20, family: .Bold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let rangeSlider: RangeSlider = {
        let slider = RangeSlider()
        slider.minValue = Attributes.minPrice
        slider.maxValue = Attributes.maxPrice
        slider.lower = Attributes.minPrice
        slider.upper = Attributes.maxPrice
        slider.trackColor = .gray02
        slider.trackTintColor = .gray02
        slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)
        return slider
    }()
    
    private let bottomView = CustomBottomView(backButtonState: .enabled, nextButtonEnabled: true)
    
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
        configNavigationBar(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configNavigationBar(isHidden: false)
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        [
            headerView,
            valueLabel,
            rangeSlider,
            bottomView
        ].forEach(view.addSubview(_:))
        setupAutoLayout()
    }
    
    private func bind() {
        viewModel.$flowerPriceModel
            .receive(on: RunLoop.main)
            .sink { [weak self] model in
                self?.valueLabel.text = self?.viewModel.getPriceString()
                self?.rangeSlider.lower = Double(model.minPrice)
                self?.rangeSlider.upper = Double(model.maxPrice)
//                self?.nextButton.isActive = true
                self?.rangeSlider.trackTintColor = .second1
            }
            .store(in: &viewModel.cancellables)
    }
    
    // MARK: - Actions
    
    @objc
    private func changeValue() {
        viewModel.setPrice(min: rangeSlider.lower, max: rangeSlider.upper)
    }
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func nextButtonTapped() {
        let price = viewModel.flowerPriceModel
        viewModel.dataManager.setPrice(BouquetData.Price(min: price.minPrice, max: price.maxPrice))
        coordinator?.showPhotoSelectionVC()
    }
}

// MARK: - AutoLayout

extension FlowerPriceViewController {
    private func setupAutoLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
        }
        
        valueLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(56)
            $0.centerX.equalToSuperview()
        }
        
        rangeSlider.snp.makeConstraints {
            $0.top.equalTo(valueLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(21)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
