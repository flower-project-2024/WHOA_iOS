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
        static let colorTypeResultViewTopOffset = 32.0
        static let colorTypeResultViewHeight = 56.0
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
    
    private lazy var colorTypeResultViewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer()
        colorTypeResultView.addGestureRecognizer(tapGesture)
        return tapGesture.publisher(for: \.state)
            .filter { $0 == .ended }
            .map { _ in }
            .eraseToAnyPublisher()
    }()
    
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
    private let colorTypeResultView = ColorTypeResultView()
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
            colorTypeResultView,
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
            backButtonTapped: bottomView.backButtonTappedPublisher,
            nextButtonTapped: bottomView.nextButtonTappedPublisher
        )
        let output = viewModel.transform(input: input)
        
        output.initialColorType
            .sink { [weak self] colorType in
                guard let self = self else { return }
                self.updateUI(for: colorType)
                self.segmentControlView.resetColorButtons()
            }
            .store(in: &cancellables)
        
        output.initialHexColor
            .sink { [weak self] hexColors in
                guard let self = self else { return }
                hexColors.enumerated().forEach { index, hexColor in
                    self.colorSelectionResultView.updateColorSelection(hexString: hexColor, for: index)
                }
            }
            .store(in: &cancellables)
        
        output.dismissView
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        output.showFlowerSelection
            .sink { [weak self] _ in
                self?.coordinator?.showFlowerSelectionVC()
            }
            .store(in: &cancellables)
        
        output.isNextButtonEnabled
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
        
        colorTypeResultViewTapPublisher
            .sink { [weak self] _ in
                self?.toggleDropdown()
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(for colorType: NumberOfColorsType) {
        colorTypeResultView.updateSelectionLabel(colorType)
        colorTypeSelectionButtonsView.updateButton(colorType)
        colorSelectionResultView.config(colorType)
        updateViewVisibility(colorType)
    }
    
    private func updateViewVisibility(_ colorType: NumberOfColorsType) {
        let hasValidColorType = colorType != .none
        colorSelectionResultView.isHidden = !hasValidColorType
        segmentControlView.isHidden = !hasValidColorType
    }
    
    private func toggleDropdown() {
        colorTypeSelectionButtonsView.isHidden.toggle()
        
        let isHidden = colorTypeSelectionButtonsView.isHidden
        updateLayoutForDropdownState(isHidden: isHidden)
        colorTypeResultView.updateChevronImage(isExpanded: isHidden)
    }
    
    private func updateLayoutForDropdownState(isHidden: Bool) {
        colorSelectionResultView.snp.remakeConstraints {
            if isHidden {
                $0.top.equalTo(colorTypeResultView.snp.bottom).offset(Metric.elementVerticalSpacing)
            } else {
                $0.top.equalTo(colorTypeSelectionButtonsView.snp.bottom).offset(Metric.sideMargin + Metric.elementVerticalSpacing)
            }
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Metric.colorSelectionResultViewHeight)
        }
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
        
        colorTypeResultView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(Metric.colorTypeResultViewTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
            $0.height.equalTo(Metric.colorTypeResultViewHeight)
        }
        
        colorTypeSelectionButtonsView.snp.makeConstraints {
            $0.top.equalTo(colorTypeResultView.snp.bottom).offset(Metric.sideMargin)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
            $0.height.equalToSuperview().multipliedBy(Metric.colorTypeSelectionButtonsHeightMultiplier)
        }
        
        colorSelectionResultView.snp.makeConstraints {
            $0.top.equalTo(colorTypeSelectionButtonsView.snp.bottom).offset(Metric.sideMargin + Metric.elementVerticalSpacing)
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
