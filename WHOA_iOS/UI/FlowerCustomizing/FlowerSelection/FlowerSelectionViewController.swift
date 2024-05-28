//
//  FlowerSelectionViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/23/24.
//

import UIKit

class FlowerSelectionViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel = FlowerSelectionViewModel()
    var tempHashTag = ["전체", "사랑", "행운", "믿음", "추억", "존경", "믿음", "우정"]

    // MARK: - UI
    
    private let exitButton = ExitButton()
    private let progressHStackView = CustomProgressHStackView(numerator: 3, denominator: 7)
    private let titleLabel = CustomTitleLabel(text: "")
    private let descriptionLabel = CustomDescriptionLabel(text: "최대 3개의 꽃을 선택할 수 있어요", numberOfLines: 1)
    
    private let flowerImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray2
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray4.cgColor
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
        imageView.backgroundColor = .gray2
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray4.cgColor
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
        imageView.backgroundColor = .gray2
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray4.cgColor
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
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.gray3.cgColor
        
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
    
    init() {
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
    
    // MARK: - Fuctions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(exitButton)
        view.addSubview(progressHStackView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
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
        titleLabel.text = "\(PurposeType.affection.rawValue)과\n어울리는 꽃 선택"
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
                self?.fetchFailure(error)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func fetchData() {
        viewModel.fetchFlowerKeyword(keywordId: "0")
    }
    
    private func fetchFailure(_ error: NetworkError) {
        let networkAlertController = self.networkErrorAlert(error)
        DispatchQueue.main.async { [unowned self] in
            self.present(networkAlertController, animated: true)
        }
    }
    
    private func networkErrorAlert(_ error: NetworkError) -> UIAlertController {
        let alertController = UIAlertController(title: "네트워크 에러 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
    
    private func setupCollectionView() {
        hashTagCollectionView.delegate = self
        hashTagCollectionView.dataSource = self
        hashTagCollectionView.register(
            HashTagCollectionViewCell.self,
            forCellWithReuseIdentifier: CellIdentifier.hashTagCellIdentifier)
        hashTagCollectionView.backgroundColor = .white
    }
    
    private func updateFlowerImageViews(with urls: [URL?]) {
        let flowerImageViews = [
            self.flowerImageView1,
            self.flowerImageView2,
            self.flowerImageView3
        ]
        let minusImageViews = [
            self.minusImageView1,
            self.minusImageView2,
            self.minusImageView3
        ]
        
        for (imageView, minusView) in zip(flowerImageViews, minusImageViews) {
            imageView.image = nil
            minusView.isHidden = true
        }
        
        for i in urls.indices {
            if let url = urls[i] {
                flowerImageViews[i].load(url: url)
                minusImageViews[i].isHidden = false
            }
        }
    }
    
    // MARK: - Actions
    
    @objc
    func minusImageViewTapped(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        
        let flowerImageViews = [flowerImageView1, flowerImageView2, flowerImageView3]
        let imageViews = [minusImageView1, minusImageView2, minusImageView3]
        
        guard let indexToRemove = imageViews.firstIndex(of: imageView) else { return }
        
        flowerImageViews[indexToRemove].image = nil
        imageViews[indexToRemove].isHidden = true
        
        updateTableViewButtonUI(at: indexToRemove, isSelected: false)
        viewModel.popSelectedFlowerModel(at: indexToRemove)
    }
    
    func updateTableViewButtonUI(at index: Int, isSelected: Bool) {
        let model = viewModel.getSelectedFlowerModel(idx: index)
        guard let indexPath = viewModel.findCellIndexPathRow(for: model) else { return }
        
        if let cell = flowerSelectionTableView.cellForRow(at: IndexPath(row: indexPath, section: 0)) as? FlowerSelectionTableViewCell {
            cell.isAddImageButtonSelected = isSelected
        }
    }
    
    @objc
    func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    func nextButtonTapped() {
        let flowerReplacementVC = AlternativesViewController()
        flowerReplacementVC.sheetPresentationController?.detents = [.medium()]
        
        present(flowerReplacementVC, animated: true)
    }
}

extension FlowerSelectionViewController {
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
            $0.trailing.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        flowerImageView1.snp.makeConstraints {
            $0.size.equalTo(48)
        }
        
        flowerImageViewHStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
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

extension FlowerSelectionViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellIdentifier.hashTagCellIdentifier,
            for: indexPath) as? HashTagCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.row == 0 {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        
        cell.setupHashTag(text: tempHashTag[indexPath.row])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let title = tempHashTag[indexPath.row]
        viewModel.filterModels(with: title)
    }
    
}
// MARK: - UICollectionViewDelegate

extension FlowerSelectionViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return tempHashTag.count
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FlowerSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 36)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 7 - 2, height: collectionView.frame.height / 1.5)
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
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let model = viewModel.getFilterdModel(idx: indexPath.row)
        cell.configUI(model: model)
        
        cell.isAddImageButtonSelected = viewModel.selectedFlowerModels.contains(where: { $0 == model })
        
        cell.addImageButtonClicked = { [weak self] in
            guard let self = self else { return }
            
            if !cell.isAddImageButtonSelected && self.viewModel.getSelectedFlowerModelCount() < 3 {
                cell.isAddImageButtonSelected = true
                self.viewModel.pushKeywordModel(model: model)
            } else {
                cell.isAddImageButtonSelected = false
                self.viewModel.popKeywordModel(model: model)
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FlowerSelectionViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
