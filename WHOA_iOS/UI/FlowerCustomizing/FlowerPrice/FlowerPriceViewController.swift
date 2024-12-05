//
//  FlowerPriceViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 3/10/24.
//

import UIKit
import Combine

final class FlowerPriceViewController: UIViewController {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let sideMargin = 20.0
        static let requestDetailViewTopOffset = 37.0
        static let valueLabelTopOffset = 56.0
        static let rangeSliderTopOffset = 20.0
        static let rangeSliderHeight = 21.0
        static let bottomViewTopOffset = 22.0
    }
    
    /// Attributes
    private enum Attributes {
        static let headerViewTitle = "원하는 가격대 범위를\n설정해주세요"
    }
    
    // MARK: - Properties
    
    private let viewModel: FlowerPriceViewModel
    weak var coordinator: CustomizingCoordinator?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI
    
    private let headerView = CustomHeaderView(
        numerator: 5,
        title: Attributes.headerViewTitle
    )
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(size: 20, family: .Bold)
        label.textColor = .black
        return label
    }()
    
    private let rangeSlider = RangeSlider()
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
        setupUI()
        bind()
        observe()
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
        let input = FlowerPriceViewModel.Input(
            minPriceChanged: rangeSlider.lowerPublisher,
            maxPriceChanged: rangeSlider.upperPublisher,
            nextButtonTapped: bottomView.nextButtonTappedPublisher
        )
        let output = viewModel.transform(input: input)
        
        output.initPriceRange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] minPrice, maxPrice in
                self?.rangeSlider.setLowerValue(Double(minPrice))
                self?.rangeSlider.setUpperValue(Double(maxPrice))
            }
            .store(in: &cancellables)
        
        output.updatePriceLabel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] priceText in
                self?.valueLabel.text = priceText
            }
            .store(in: &cancellables)
        
        output.showPhotoSelectionView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.showPhotoSelectionVC()
            }
            .store(in: &cancellables)
    }
    
    private func observe() {
        headerView.exitButtonTappedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.showExitAlertVC(from: self)
            }
            .store(in: &cancellables)
        
        bottomView.backButtonTappedPublisher
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
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
            $0.top.equalTo(headerView.snp.bottom).offset(Metric.valueLabelTopOffset)
            $0.centerX.equalToSuperview()
        }
        
        rangeSlider.snp.makeConstraints {
            $0.top.equalTo(valueLabel.snp.bottom).offset(Metric.rangeSliderTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
            $0.height.equalTo(Metric.rangeSliderHeight)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
