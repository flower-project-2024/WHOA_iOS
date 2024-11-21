//
//  PhotoSelectionViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 3/11/24.
//

import UIKit
import Photos

final class PhotoSelectionViewController: UIViewController {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let sideMargin = 20.0
        static let requirementTextViewTopOffset = 16.0
        static let requirementTextViewHeightMultiplier = 0.34
    }
    
    /// Attributes
    private enum Attributes {
        static let headerViewTitle = "추가로 사장님께\n요구할 사항들을 작성해주세요"
        static let requirementLabelText = "요구사항"
        static let photoLabelText = "참고 사진"
    }
    
    // MARK: - Properties
    
    private let viewModel: PhotoSelectionViewModel
    weak var coordinator: CustomizingCoordinator?
    
    // MARK: - UI
    
    private lazy var headerView = CustomHeaderView(
        currentVC: self,
        coordinator: coordinator,
        numerator: 6,
        title: Attributes.headerViewTitle
    )
    
    private lazy var requirementLabel = buildLabel(text: Attributes.requirementLabelText)
    private let requirementTextView = RequirementTextView()
    private lazy var photoLabel = buildLabel(text: Attributes.photoLabelText)
    
    private lazy var addImageButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.circle")
        imageView.tintColor = .black
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray02
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(photoImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let photoImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PhotoIcon")
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray02
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var minusImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MinusButton")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.tag = 1
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(minusImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let photoImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PhotoIcon")
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray02
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var minusImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MinusButton")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.tag = 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(minusImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let photoImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PhotoIcon")
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray02
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var minusImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MinusButton")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.tag = 3
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(minusImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var photoImageViewHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            addImageButton,
            photoImageView1,
            photoImageView2,
            photoImageView3
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private let photoImageHScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let bottomView = CustomBottomView(backButtonState: .enabled, nextButtonEnabled: true)
    
    // MARK: - Initialize
    
    init(viewModel: PhotoSelectionViewModel) {
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
        configUI()
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
            requirementLabel,
            requirementTextView,
            bottomView
            
        ].forEach(view.addSubview(_:))
        
        view.addSubview(photoLabel)
        view.addSubview(photoImageHScrollView)
        photoImageHScrollView.addSubview(photoImageViewHStackView)
        
        photoImageView1.addSubview(minusImageView1)
        photoImageView2.addSubview(minusImageView2)
        photoImageView3.addSubview(minusImageView3)
        
        setupAutoLayout()
    }
    
    private func configUI() {
        updateImageViews(with: viewModel.photoSelectionModel.photoDatas)
        updateMinusImageViews()
    }
    
    private func resetImageViews() {
        photoImageView1.image = UIImage(named: "PhotoIcon")
        photoImageView2.image = UIImage(named: "PhotoIcon")
        photoImageView3.image = UIImage(named: "PhotoIcon")
        photoImageView1.contentMode = .center
        photoImageView2.contentMode = .center
        photoImageView3.contentMode = .center
    }
    
    private func updateImageViews(with photos: [Data]) {
        for (index, data) in photos.enumerated() {
            switch index {
            case 0:
                photoImageView1.image = UIImage(data: data)
                photoImageView1.contentMode = .scaleAspectFill
            case 1:
                photoImageView2.image = UIImage(data: data)
                photoImageView2.contentMode = .scaleAspectFill
            case 2:
                photoImageView3.image = UIImage(data: data)
                photoImageView3.contentMode = .scaleAspectFill
            default:
                break
            }
        }
    }
    private func updateMinusImageViews() {
        minusImageView1.isHidden = photoImageView1.image == UIImage(named: "PhotoIcon")
        minusImageView2.isHidden = photoImageView2.image == UIImage(named: "PhotoIcon")
        minusImageView3.isHidden = photoImageView3.image == UIImage(named: "PhotoIcon")
    }
    
    private func buildLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .Pretendard(size: 16, family: .SemiBold)
        return label
    }
    
    // MARK: - Actions
    
    @objc
    func minusImageViewTapped(_ sender: UITapGestureRecognizer) {
        let idx = sender.view?.tag == 1 ? 0 : sender.view?.tag == 2 ? 1 : 2
        
        viewModel.photoSelectionModel.photoDatas.remove(at: idx)
        resetImageViews()
        updateImageViews(with: viewModel.getPhotosArray())
        updateMinusImageViews()
    }
    
    @objc
    func photoImageViewTapped() {
        viewModel.authService.requestAuthorization { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                let vc = PhotoViewController(photosCount: viewModel.getPhotosCount(), photoSelectionLimitCount: 3)
                vc.modalPresentationStyle = .fullScreen
                vc.completionHandler = { photos in
                    let photoDatas = photos.values.compactMap{ $0 }.compactMap{ $0.pngData() }
                    self.viewModel.addPhotos(photos: photoDatas)
                    
                    for i in 0..<self.viewModel.getPhotosCount() {
                        switch i {
                        case 0:
                            self.photoImageView1.image = UIImage(data: self.viewModel.getPhoto(idx: i))
                            self.photoImageView1.contentMode = .scaleAspectFill
                            self.minusImageView1.isHidden = false
                        case 1:
                            self.photoImageView2.image = UIImage(data: self.viewModel.getPhoto(idx: i))
                            self.photoImageView2.contentMode = .scaleAspectFill
                            self.minusImageView2.isHidden = false
                        case 2:
                            self.photoImageView3.image = UIImage(data: self.viewModel.getPhoto(idx: i))
                            self.photoImageView3.contentMode = .scaleAspectFill
                            self.minusImageView3.isHidden = false
                        default:
                            continue
                        }
                    }
                    
                    switch self.viewModel.getPhotosCount() {
                    case 1:
                        self.photoImageView3.image = UIImage(named: "PhotoIcon")
                        self.photoImageView3.contentMode = .center
                    case 0:
                        self.photoImageView3.image = UIImage(named: "PhotoIcon")
                        self.photoImageView2.image = UIImage(named: "PhotoIcon")
                        self.photoImageView3.contentMode = .center
                        self.photoImageView2.contentMode = .center
                    default:
                        break
                    }
                }
                
                present(vc, animated: true)
                
            case .failure:
                return
            }
        }
    }
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func nextButtonTapped() {
        let model = viewModel.getPhotoSelectionModel()
        viewModel.dataManager.setRequirement(BouquetData.Requirement(text: model.text, images: model.photoDatas))
        coordinator?.showCustomizingSummaryVC()
    }
}

// MARK: - AutoLayout

extension PhotoSelectionViewController {
    private func setupAutoLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
        }
        
        requirementLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        
        requirementTextView.snp.makeConstraints {
            $0.top.equalTo(requirementLabel.snp.bottom).offset(Metric.requirementTextViewTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
            $0.height.equalTo(self.requirementTextView.snp.width).multipliedBy(Metric.requirementTextViewHeightMultiplier)
        }
        
        photoLabel.snp.makeConstraints {
            $0.top.equalTo(requirementTextView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(280)
        }
        
        photoImageView1.snp.makeConstraints {
            $0.width.equalTo(130.adjusted())
            $0.height.equalTo(136.adjustedH())
        }
        
        photoImageViewHStackView.snp.makeConstraints {
            $0.edges.equalTo(photoImageHScrollView)
            $0.height.equalTo(photoImageHScrollView)
        }
        
        photoImageHScrollView.snp.makeConstraints {
            $0.top.equalTo(photoLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
        }
        
        [minusImageView1, minusImageView2, minusImageView3].forEach { imageView in
            imageView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(5)
                $0.trailing.equalToSuperview().offset(-5)
                $0.size.equalTo(16)
            }
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
