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
    }
    
    /// Attributes
    private enum Attributes {
        static let headerViewDescription = "최대 3개의 꽃을 선택할 수 있어요"
        
        static func headerViewTitle(for purpose: String) -> String {
            return "\(purpose)과\n어울리는 꽃 선택"
        }
    }
    
    // MARK: - Properties
    
    let viewModel: FlowerSelectionViewModel
    weak var coordinator: CustomizingCoordinator?
    
    private var flowerImageViews: [UIImageView] = []
    private var minusImageViews: [UIImageView] = []
    
    // MARK: - UI
    
    private lazy var headerView = CustomHeaderView(
        currentVC: self,
        coordinator: coordinator,
        numerator: 3,
        title: Attributes.headerViewTitle(for: viewModel.getPurposeString()),
        description: Attributes.headerViewDescription
    )
    
    private let flowerImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray02
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray04.cgColor
        return imageView
    }()
    
    private lazy var minusImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MinusButton")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(minusImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let flowerImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray02
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray04.cgColor
        return imageView
    }()
    
    private lazy var minusImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MinusButton")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(minusImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let flowerImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray02
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray04.cgColor
        return imageView
    }()
    
    private lazy var minusImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MinusButton")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(minusImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var flowerImageViewHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            flowerImageView1,
            flowerImageView2,
            flowerImageView3
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private let hashTagCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.gray03.cgColor
        
        return collectionView
    }()
    
    private lazy var flowerSelectionTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.rowHeight = 120
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(
            FlowerSelectionTableViewCell.self,
            forCellReuseIdentifier: CellIdentifier.flowerSelectionTableViewCellIdentifier
        )
        return tableView
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
        fetchData()
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
        
        view.addSubview(headerView)
        
        view.addSubview(flowerImageViewHStackView)
        view.addSubview(minusImageView1)
        view.addSubview(minusImageView2)
        view.addSubview(minusImageView3)
        
        view.addSubview(hashTagCollectionView)
        view.addSubview(flowerSelectionTableView)
        
        view.addSubview(borderLine)
        view.addSubview(navigationHStackView)
        
        setupAutoLayout()
        setupCollectionView()
        setupImageViews()
        selectInitialItem()
    }
    
    private func setupImageViews() {
        flowerImageViews = [flowerImageView1, flowerImageView2, flowerImageView3]
        minusImageViews = [minusImageView1, minusImageView2, minusImageView3]
    }
    
    private func bind() {
        viewModel.$filteredModels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.flowerSelectionTableView.reloadData()
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$selectedFlowerModels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let selectedImages = self?.viewModel.getSelectedFlowerModelImagesURL() else { return }
                
                self?.updateFlowerImageViews(with: selectedImages)
                self?.nextButton.isActive = !model.isEmpty
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$networkError
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showAlert(title: "네트워킹 오류", message: error.localizedDescription)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func fetchData() {
        viewModel.fetchFlowerKeyword()
    }
    
    private func setupCollectionView() {
        hashTagCollectionView.delegate = self
        hashTagCollectionView.dataSource = self
        hashTagCollectionView.register(
            HashTagCollectionViewCell.self,
            forCellWithReuseIdentifier: CellIdentifier.hashTagCellIdentifier)
        hashTagCollectionView.backgroundColor = .white
    }
    
    private func selectInitialItem() {
        let initialIndexPath = IndexPath(item: 0, section: 0)
        hashTagCollectionView.selectItem(at: initialIndexPath, animated: false, scrollPosition: .init())
        
        if let cell = hashTagCollectionView.cellForItem(at: initialIndexPath) as? HashTagCollectionViewCell {
            cell.isSelected = true
        }
        
        let title = viewModel.keyword[initialIndexPath.row].rawValue
        viewModel.filterModels(with: title)
    }
    
  
    private func updateFlowerImageViews(with urlStrings: [String?]) {
        resetImageView()
        
        for (index, urlString) in urlStrings.enumerated() {
            updateImageView(at: index, with: urlString)
        }
    }
    
    private func updateImageView(at index: Int, with urlString: String?) {
        guard index < flowerImageViews.count else { return }
        let flowerImageView = flowerImageViews[index]
        let minusImageView = minusImageViews[index]
        
        if let url = urlString {
            ImageProvider.shared.setImage(into: flowerImageView, from: url)
        } else {
            flowerImageView.image = .defaultFlower
        }
        
        minusImageView.isHidden = false
    }
    
    private func resetImageView() {
        flowerImageViews.forEach { $0.image = nil }
        minusImageViews.forEach { $0.isHidden = true }
    }
    
    // MARK: - Actions
    
    @objc
    func minusImageViewTapped(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView,
              let indexToRemove = minusImageViews.firstIndex(of: imageView)
        else { return }
        
        viewModel.popSelectedFlowerModel(at: indexToRemove)
        flowerSelectionTableView.reloadData()
    }
    
    @objc
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func nextButtonTapped() {
        let flowers = viewModel.convertFlowerKeywordModelToFlower(with: viewModel.selectedFlowerModels)
        viewModel.dataManager.setFlowers(flowers)
        coordinator?.showAlternativesVC(from: self)
    }
}

extension FlowerSelectionViewController {
    private func setupAutoLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
            $0.height.equalTo(Metric.headerViewHeight)
        }
        
        flowerImageView1.snp.makeConstraints {
            $0.size.equalTo(48)
        }
        
        flowerImageViewHStackView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        minusImageView1.snp.makeConstraints {
            $0.top.trailing.equalTo(flowerImageView1).inset(2)
            $0.size.equalTo(16)
        }
        
        minusImageView2.snp.makeConstraints {
            $0.top.trailing.equalTo(flowerImageView2).inset(2)
            $0.size.equalTo(16)
        }
        
        minusImageView3.snp.makeConstraints {
            $0.top.trailing.equalTo(flowerImageView3).inset(2)
            $0.size.equalTo(16)
        }
        
        hashTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(flowerImageViewHStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        flowerSelectionTableView.snp.makeConstraints {
            $0.top.equalTo(hashTagCollectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(borderLine)
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

// MARK: - UICollectionViewDataSource

extension FlowerSelectionViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.keyword.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellIdentifier.hashTagCellIdentifier,
            for: indexPath) as? HashTagCollectionViewCell else { return UICollectionViewCell() }
        
        if collectionView.indexPathsForSelectedItems?.contains(indexPath) == true {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        
        cell.setupHashTag(text: viewModel.keyword[indexPath.row].rawValue)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let title = viewModel.keyword[indexPath.row].rawValue
        viewModel.filterModels(with: title)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FlowerSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let label = UILabel()
        label.text = viewModel.keyword[indexPath.item].rawValue
        label.sizeToFit()
        return CGSize(width: label.frame.width + 18, height: label.frame.height + 16)
    }
}

// MARK: - UITableViewDataSource

extension FlowerSelectionViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.getFilterdModelsCount()
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellIdentifier.flowerSelectionTableViewCellIdentifier,
            for: indexPath
        ) as? FlowerSelectionTableViewCell else { return UITableViewCell() }
        
        let model = viewModel.getFilterdModel(idx: indexPath.row)
        
        cell.configUI(model: model)
        cell.isAddImageButtonSelected = viewModel.selectedFlowerModels.contains(where: { $0 == model })
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FlowerSelectionViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        didTapAddImageButton(row: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    private func didTapAddImageButton(row: Int) {
        let model = viewModel.getFilterdModel(idx: row)
        
        if viewModel.selectedFlowerModels.contains(model) {
            viewModel.popFlowerModel(model: model)
        } else if viewModel.getSelectedFlowerModelCount() < 3 {
            viewModel.pushFlowerModel(model: model)
        }
    }
}
