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

    private lazy var headerView = CustomHeaderView(
        currentVC: self,
        coordinator: coordinator,
        numerator: 2,
        title: "꽃 조합 색",
        description: "원하는 느낌의 꽃 조합 색을 선택해주세요"
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
        bindTapGesture()
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
                self?.updateUI(for: colorType)
                self?.segmentControlView.resetColorButtons()
            }
            .store(in: &cancellables)
        
        output.initialHexColor
            .sink { [weak self] hexColor in
                self?.colorSelectionResultView.updateColorSelection(hexString: hexColor)
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
    
    private func bindTapGesture() {
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
        let isHidden = colorTypeSelectionButtonsView.isHidden
        colorTypeSelectionButtonsView.isHidden.toggle()
        colorTypeResultView.updateChevronImage(isExpanded: !isHidden)
    }
}

// MARK: - AutoLayout

// 고민사항 multipliedBy와 고정 height 어떤 기준을 사용하는게 좋을까?
extension FlowerColorPickerViewController {
    private func setupAutoLayout() {
        let margin: CGFloat = 20
        let vSpacing: CGFloat = 24
        
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
            $0.leading.trailing.equalToSuperview().inset(margin)
            $0.height.equalTo(178)
        }
        
        colorTypeResultView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(margin)
            $0.height.equalToSuperview().multipliedBy(0.07)
        }
        
        colorTypeSelectionButtonsView.snp.makeConstraints {
            $0.top.equalTo(colorTypeResultView.snp.bottom).offset(margin)
            $0.leading.trailing.equalToSuperview().inset(margin)
            $0.height.equalToSuperview().multipliedBy(0.045)
        }
        
        colorSelectionResultView.snp.makeConstraints {
            $0.top.equalTo(colorTypeSelectionButtonsView.snp.bottom).offset(margin + vSpacing)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.269)
        }
        
        segmentControlView.snp.makeConstraints {
            $0.top.equalTo(colorSelectionResultView.snp.bottom).offset(vSpacing)
            $0.leading.trailing.bottom.equalToSuperview().inset(margin)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
