//
//  FlowerColorPickerViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import UIKit
import SnapKit
import Combine

final class FlowerColorPickerViewController: UIViewController {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let sideMargin = 20.0
        static let headerViewHeight = 178.0
        static let colorTypeSelectionButtonsViewTopOffset = 15.0
        static let colorTypeSelectionButtonsHeightMultiplier = 0.045
        static let elementVerticalSpacing = 24.0
        static let colorSelectionResultViewHeight = 217.0
    }
    
    /// Attributes
    private enum Attributes {
        static let headerViewTitle = "꽃 조합 색"
        static let headerViewDescription = "원하는 느낌의 꽃 조합 색을 선택해주세요"
    }
    
    // MARK: - Properties
    
    private let viewModel: FlowerColorPickerViewModel
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: CustomizingCoordinator?
    
    // MARK: - UI
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    private let contentView = UIView()
    private let headerView = CustomHeaderView(
        numerator: 2,
        title: Attributes.headerViewTitle,
        description: Attributes.headerViewDescription
    )
    private let colorTypeSelectionButtonsView = ColorTypeSelectionButtonsView()
    private let colorSelectionResultView = ColorSelectionResultView()
    private let segmentControlView = SegmentControlView()
    private let bottomView = CustomBottomView(backButtonState: .enabled, nextButtonEnabled: false)
    
    // MARK: - Initialize
    
    init(viewModel: FlowerColorPickerViewModel = FlowerColorPickerViewModel()) {
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
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            headerView,
            colorTypeSelectionButtonsView,
            colorSelectionResultView,
            segmentControlView,
        ].forEach(contentView.addSubview(_:))
        
        view.addSubview(bottomView)
        
        setupAutoLayout()
    }
    
    private func bind() {
        let input = FlowerColorPickerViewModel.Input(
            colorTypeSelected: colorTypeSelectionButtonsView.valuePublisher,
            hexColorSelected: segmentControlView.valuePublisher,
            resultButtonIndex: colorSelectionResultView.selectedButtonIndexPublisher,
            nextButtonTapped: bottomView.nextButtonTappedPublisher
        )
        let output = viewModel.transform(input: input)
        
        output.initialColorType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] colorType in
                guard let self = self else { return }
                self.updateUI(for: colorType)
            }
            .store(in: &cancellables)
        
        output.initialHexColor
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hexColors in
                guard let self = self else { return }
                hexColors.enumerated().forEach { index, hexColor in
                    self.colorSelectionResultView.updateColorSelection(hexString: hexColor, for: index)
                }
            }
            .store(in: &cancellables)
        
        output.showFlowerSelection
            .sink { [weak self] _ in
                self?.coordinator?.showFlowerSelectionVC()
            }
            .store(in: &cancellables)
        
        output.isNextButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bool in
                self?.bottomView.configNextButton(bool)
            }
            .store(in: &cancellables)
        
        segmentControlView.bind(with: colorSelectionResultView.selectedColorPublisher)
    }
    
    private func observe() {
        headerView.exitButtonTappedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.coordinator?.showExitAlertVC(from: self)
            }
            .store(in: &cancellables)
        
        bottomView.backButtonTappedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(for colorType: NumberOfColorsType) {
        colorTypeSelectionButtonsView.updateButton(colorType)
        colorSelectionResultView.config(colorType)
    }
}

// MARK: - AutoLayout

// 고민사항 multipliedBy와 고정 height 어떤 기준을 사용하는게 좋을까?
extension FlowerColorPickerViewController {
    private func setupAutoLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
            $0.height.equalTo(Metric.headerViewHeight)
        }
        
        colorTypeSelectionButtonsView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(Metric.colorTypeSelectionButtonsViewTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
            $0.height.equalToSuperview().multipliedBy(Metric.colorTypeSelectionButtonsHeightMultiplier)
        }
        
        colorSelectionResultView.snp.makeConstraints {
            $0.top.equalTo(colorTypeSelectionButtonsView.snp.bottom).offset(Metric.elementVerticalSpacing)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Metric.colorSelectionResultViewHeight)
        }
        
        segmentControlView.snp.makeConstraints {
            $0.top.equalTo(colorSelectionResultView.snp.bottom).offset(Metric.elementVerticalSpacing)
            $0.leading.trailing.bottom.equalToSuperview().inset(Metric.sideMargin)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
