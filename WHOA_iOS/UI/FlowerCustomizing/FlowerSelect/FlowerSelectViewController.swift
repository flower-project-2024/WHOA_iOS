//
//  FlowerSelectViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/23/24.
//

import UIKit

class FlowerSelectViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel = FlowerSelectViewModel()
    var tempModel: FlowerColorPickerModel
    var tempHashTag = ["전체", "사랑", "감사", "기쁨", "우정", "존경", "믿음", "추억"]
    var tempImage = ["IntentImage", "WhoaLogo", "TempFlower"]
    
    // MARK: - UI
    
    private let exitButton = ExitButton()
    private let progressHStackView = CustomProgressHStackView(numerator: 3, denominator: 7)
    private let titleLabel = CustomTitleLabel(text: "")
    private let descriptionLabel = CustomDescriptionLabel(text: "최대 3개의 꽃을 선태할 수 있어요", numberOfLines: 1)
    
    private let flowerImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray5
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray5.cgColor
        return imageView
    }()
    
    private let flowerImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray5
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray5.cgColor
        return imageView
    }()
    
    private let flowerImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray5
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray5.cgColor
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
        collectionView.layer.borderColor = UIColor.systemGray5.cgColor
        
        return collectionView
    }()
    
    private lazy var flowerSelectTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 120
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(
            FlowerSelectTableViewCell.self,
            forCellReuseIdentifier: CellIdentifier.flowerSelectTableViewCellIdentifier
        )
        return tableView
    }()
    
    private let backButton = BackButton(isActive: true)
    private let nextButton = NextButton()
    
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
    
    init(tempModel: FlowerColorPickerModel) {
        self.tempModel = tempModel
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
        nextButton.isActive = true
    }
    
    // MARK: - Fuctions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(exitButton)
        view.addSubview(progressHStackView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(flowerImageViewHStackView)
        view.addSubview(hashTagCollectionView)
        view.addSubview(flowerSelectTableView)
        view.addSubview(navigationHStackView)

        setupAutoLayout()
        setupCollectionView()
        setupButtonActions()
        titleLabel.text = "\"\(tempModel.intentType.rawValue)\"과 어울리는 꽃 선택"
    }
    
    private func bind() {
        viewModel.flowerImagesDidChage = { [weak self] images in
            self?.flowerImageView1.image = UIImage(named: images[0])
            
            if images.count > 1 {
                self?.flowerImageView2.image = UIImage(named: images[1])
            }
            
            if images.count > 2 {
                self?.flowerImageView3.image = UIImage(named: images[2])
            }
        }
    }
    
    private func setupCollectionView() {
        hashTagCollectionView.delegate = self
        hashTagCollectionView.dataSource = self
        hashTagCollectionView.register(HashTagCollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifier.hashTagCellIdentifier)
        hashTagCollectionView.backgroundColor = .white
    }
    
    private func setupButtonActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc
    func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    func nextButtonTapped() {
        viewModel.goToNextVC(fromCurrentVC: self, animated: true)
    }
}

extension FlowerSelectViewController {
    private func setupAutoLayout() {
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(17)
        }
        
        progressHStackView.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(12.75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressHStackView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(200)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(160)
        }
        
        flowerImageView1.snp.makeConstraints {
            $0.size.equalTo(48)
        }
        
        flowerImageViewHStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(202)
        }
        
        hashTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(flowerImageViewHStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        flowerSelectTableView.snp.makeConstraints {
            $0.top.equalTo(hashTagCollectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(navigationHStackView.snp.top).offset(-20)
        }
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(56)
        }
        
        navigationHStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-11.5)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FlowerSelectViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempHashTag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.hashTagCellIdentifier, for: indexPath) as? HashTagCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.row == 0 {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }

        cell.setupHashTag(text: tempHashTag[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FlowerSelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width / 7 - 2, height: collectionView.frame.height / 1.5)
    }
}

// MARK: - UITableViewDataSource

extension FlowerSelectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.flowerSelectTableViewCellIdentifier, for: indexPath) as? FlowerSelectTableViewCell
                else { return UITableViewCell() }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.flowerImageView.image = UIImage(named: tempImage[indexPath.row])
        
        cell.addImageButtonClicked = { [weak self] in
            self?.viewModel.addFlowerImage(imageString: self?.tempImage[indexPath.row])
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FlowerSelectViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        flowerSelectTableView.deselectRow(at: indexPath, animated: false)
    }
}
