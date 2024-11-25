//
//  PhotoSelectionViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 3/11/24.
//

import UIKit
import Combine
import SnapKit
import Photos

final class PhotoSelectionViewController: UIViewController {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let sideMargin = 20.0
        static let requirementLabelTopOffset = 30.0
        static let requirementTextViewTopOffset = 16.0
        static let requirementTextViewHeightMultiplier = 0.34
        static let photoLabelTopOffset = 40.0
    }
    
    /// Attributes
    private enum Attributes {
        static let headerViewTitle = "추가로 사장님께\n요구할 사항들을 작성해주세요"
        static let requirementLabelText = "요구사항"
        static let photoLabelText = "참고 사진"
    }
    
    // MARK: - Properties
    
    private let viewModel: PhotoSelectionViewModel
    private var cancellables = Set<AnyCancellable>()
    weak var coordinator: CustomizingCoordinator?
    
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        return tapGesture.publisher(for: \.state)
            .filter { $0 == .ended }
            .map { _ in }
            .eraseToAnyPublisher()
    }()
    
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
    private let photoSelectionView = PhotoSelectionView()
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
            requirementLabel,
            requirementTextView,
            photoLabel,
            photoSelectionView,
            bottomView
            
        ].forEach(view.addSubview(_:))
        setupAutoLayout()
    }
    
    private func bind() {
        
    }
    
    private func observe() {
        viewTapPublisher
            .sink { [weak self] _ in
                self?.view.endEditing(true)
            }
            .store(in: &cancellables)
        
        bottomView.backButtonTappedPublisher
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
    
//    private func resetImageViews() {
//        photoImageView1.image = UIImage(named: "PhotoIcon")
//        photoImageView2.image = UIImage(named: "PhotoIcon")
//        photoImageView3.image = UIImage(named: "PhotoIcon")
//        photoImageView1.contentMode = .center
//        photoImageView2.contentMode = .center
//        photoImageView3.contentMode = .center
//    }
    
//    private func updateImageViews(with photos: [Data]) {
//        for (index, data) in photos.enumerated() {
//            switch index {
//            case 0:
//                photoImageView1.image = UIImage(data: data)
//                photoImageView1.contentMode = .scaleAspectFill
//            case 1:
//                photoImageView2.image = UIImage(data: data)
//                photoImageView2.contentMode = .scaleAspectFill
//            case 2:
//                photoImageView3.image = UIImage(data: data)
//                photoImageView3.contentMode = .scaleAspectFill
//            default:
//                break
//            }
//        }
//    }
    
//    private func updateMinusImageViews() {
//        minusImageView1.isHidden = photoImageView1.image == UIImage(named: "PhotoIcon")
//        minusImageView2.isHidden = photoImageView2.image == UIImage(named: "PhotoIcon")
//        minusImageView3.isHidden = photoImageView3.image == UIImage(named: "PhotoIcon")
//    }
    
    private func buildLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = .Pretendard(size: 16, family: .SemiBold)
        return label
    }
    
    // MARK: - Actions
    
//    @objc
//    func minusImageViewTapped(_ sender: UITapGestureRecognizer) {
//        let idx = sender.view?.tag == 1 ? 0 : sender.view?.tag == 2 ? 1 : 2
//        
//        viewModel.photoSelectionModel.photoDatas.remove(at: idx)
//        resetImageViews()
//        updateImageViews(with: viewModel.getPhotosArray())
//        updateMinusImageViews()
//    }
//    
//    @objc
//    func photoImageViewTapped() {
//        viewModel.photoAuthService.requestAuthorization { [weak self] result in
//            guard let self else { return }
//            
//            switch result {
//            case .success:
//                let vc = PhotoViewController(photosCount: viewModel.getPhotosCount(), photoSelectionLimitCount: 3)
//                vc.modalPresentationStyle = .fullScreen
//                vc.completionHandler = { photos in
//                    let photoDatas = photos.values.compactMap{ $0 }.compactMap{ $0.pngData() }
//                    self.viewModel.addPhotos(photos: photoDatas)
//                    
//                    for i in 0..<self.viewModel.getPhotosCount() {
//                        switch i {
//                        case 0:
//                            self.photoImageView1.image = UIImage(data: self.viewModel.getPhoto(idx: i))
//                            self.photoImageView1.contentMode = .scaleAspectFill
//                            self.minusImageView1.isHidden = false
//                        case 1:
//                            self.photoImageView2.image = UIImage(data: self.viewModel.getPhoto(idx: i))
//                            self.photoImageView2.contentMode = .scaleAspectFill
//                            self.minusImageView2.isHidden = false
//                        case 2:
//                            self.photoImageView3.image = UIImage(data: self.viewModel.getPhoto(idx: i))
//                            self.photoImageView3.contentMode = .scaleAspectFill
//                            self.minusImageView3.isHidden = false
//                        default:
//                            continue
//                        }
//                    }
//                    
//                    switch self.viewModel.getPhotosCount() {
//                    case 1:
//                        self.photoImageView3.image = UIImage(named: "PhotoIcon")
//                        self.photoImageView3.contentMode = .center
//                    case 0:
//                        self.photoImageView3.image = UIImage(named: "PhotoIcon")
//                        self.photoImageView2.image = UIImage(named: "PhotoIcon")
//                        self.photoImageView3.contentMode = .center
//                        self.photoImageView2.contentMode = .center
//                    default:
//                        break
//                    }
//                }
//                
//                present(vc, animated: true)
//                
//            case .failure:
//                return
//            }
//        }
//    }
    
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
            $0.top.equalTo(headerView.snp.bottom).offset(Metric.requirementLabelTopOffset)
            $0.leading.equalToSuperview().offset(Metric.sideMargin)
        }
        
        requirementTextView.snp.makeConstraints {
            $0.top.equalTo(requirementLabel.snp.bottom).offset(Metric.requirementTextViewTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
            $0.height.equalTo(self.requirementTextView.snp.width).multipliedBy(Metric.requirementTextViewHeightMultiplier)
        }
        
        photoLabel.snp.makeConstraints {
            $0.top.equalTo(requirementTextView.snp.bottom).offset(Metric.photoLabelTopOffset)
            $0.leading.equalToSuperview().offset(Metric.sideMargin)
        }
        
        photoSelectionView.snp.makeConstraints {
            $0.top.equalTo(photoLabel.snp.bottom).offset(Metric.requirementTextViewTopOffset)
            $0.leading.equalToSuperview().offset(Metric.sideMargin)
            $0.trailing.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
