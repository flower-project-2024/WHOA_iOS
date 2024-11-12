//
//  FlowerSelectionViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/23/24.
//

import UIKit
import Combine

final class FlowerSelectionViewController: UIViewController {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let sideMargin = 20.0
        static let headerViewHeight = 208.0
        static let keywordHScrollViewHeight = 36
        static let tableViewRowHeight = 120.0
        static let verticalSpacing = 16.0
        static let borderLineHeight = 1.0
    }
    
    /// Attributes
    private enum Attributes {
        static let flowerListCell = "FlowerListCell"
        static let headerViewDescription = "최대 3개의 꽃을 선택할 수 있어요"
        static func headerViewTitle(for purpose: String) -> String {
            return "\(purpose)과\n어울리는 꽃 선택"
        }
    }
    
    // MARK: - Properties
    
    let viewModel: FlowerSelectionViewModel
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: CustomizingCoordinator?
    private let flowerSubject = PassthroughSubject<Int, Never>()
    
    // MARK: - UI
    
    private lazy var headerView = CustomHeaderView(
        currentVC: self,
        coordinator: coordinator,
        numerator: 3,
        title: Attributes.headerViewTitle(for: viewModel.getPurposeString()),
        description: Attributes.headerViewDescription
    )
    private let flowerImageView = FlowerImageView()
    private let topBorderLine = BorderLine()
    private let keywordHScrollView = KeywordHScrollView()
    private let bottomBorderLine = BorderLine()
    private lazy var flowerListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.rowHeight = Metric.tableViewRowHeight
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(
            FlowerListCell.self,
            forCellReuseIdentifier: Attributes.flowerListCell
        )
        return tableView
    }()
    private let bottomView = CustomBottomView(backButtonState: .enabled, nextButtonEnabled: false)
    
    // MARK: - Initialize
    
    init(viewModel: FlowerSelectionViewModel) {
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
        viewModel.fetchFlowerKeyword()
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
            flowerImageView,
            topBorderLine,
            keywordHScrollView,
            bottomBorderLine,
            flowerListTableView,
            bottomView
        ].forEach(view.addSubview(_:))
        setupAutoLayout()
    }
    
    private func bind() {
        let input = FlowerSelectionViewModel.Input(
            keywordSelected: keywordHScrollView.valuePublisher,
            flowerSelected: flowerSubject.eraseToAnyPublisher(),
            minusButtonTapped: flowerImageView.valuePublisher,
            nextButtonTapped: bottomView.nextButtonTappedPublisher
        )
        let output = viewModel.transform(input: input)
        
        output.updateFlowerList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.flowerListTableView.reloadData()
            }
            .store(in: &cancellables)
        
        output.selectedFlowers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] models in
                let urlStrings = models.compactMap { $0.flowerImage }
                self?.flowerImageView.setImages(urlStrings: urlStrings)
            }
            .store(in: &cancellables)
        
        output.deselectedFlower
            .receive(on: DispatchQueue.main)
            .sink { [weak self] row in
                guard let self = self else { return }
                let indexPath = IndexPath(row: row, section: 0)
                self.updateCellSelection(at: indexPath)
            }
            .store(in: &cancellables)
        
        output.networkError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let error = error?.localizedDescription else { return }
                self?.showAlert(message: error)
            }
            .store(in: &cancellables)
        
        bottomView.backButtonTappedPublisher
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        output.nextButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.bottomView.configNextButton(isEnabled)
            }
            .store(in: &cancellables)
        
        output.showAlternativeView
            .sink { [weak self] _ in
                self?.coordinator?.showAlternativesVC(from: self)
            }
            .store(in: &cancellables)
    }
    
    private func updateCellSelection(at indexPath: IndexPath) {
        guard let cell = flowerListTableView.cellForRow(at: indexPath) as? FlowerListCell else { return }
        let model = viewModel.getFlowerModel(index: indexPath.row)
        cell.updateAddImageView(viewModel.isModelSelected(model))
    }
    
}

extension FlowerSelectionViewController {
    private func setupAutoLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
            $0.height.equalTo(Metric.headerViewHeight)
        }
        
        flowerImageView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(Metric.verticalSpacing / 2)
            $0.leading.equalToSuperview().offset(Metric.sideMargin)
        }
        
        topBorderLine.snp.makeConstraints {
            $0.top.equalTo(flowerImageView.snp.bottom).offset(Metric.verticalSpacing)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Metric.borderLineHeight)
        }
        
        keywordHScrollView.snp.makeConstraints {
            $0.top.equalTo(topBorderLine.snp.bottom).offset(Metric.verticalSpacing)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Metric.keywordHScrollViewHeight)
        }
        
        bottomBorderLine.snp.makeConstraints {
            $0.top.equalTo(keywordHScrollView.snp.bottom).offset(Metric.verticalSpacing)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Metric.borderLineHeight)
        }
        
        flowerListTableView.snp.makeConstraints {
            $0.top.equalTo(bottomBorderLine.snp.bottom).offset(Metric.verticalSpacing)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UITableViewDataSource

extension FlowerSelectionViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.flowerModelCount
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Attributes.flowerListCell,
            for: indexPath
        ) as? FlowerListCell else { return UITableViewCell() }
        let model = viewModel.getFlowerModel(index: indexPath.row)
        let isSelected = viewModel.isModelSelected(model)
        cell.configUI(model: model, isSelected: isSelected)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FlowerSelectionViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        flowerSubject.send(indexPath.row)
        updateCellSelection(at: indexPath)
    }
}
