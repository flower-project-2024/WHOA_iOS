//
//  RequestDetailViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/4/24.
//

import UIKit

final class RequestDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: RequestDetailViewModel
    private let photoAuthService = MyPhotoAuthService()
    weak var delegate: BouquetProductionSuccessDelegate?
    var myPageVC: MyPageViewController?
    
    // MARK: - Views
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let productionCompletedLabel: HashTagCustomLabel = {
        let label = HashTagCustomLabel(padding: .init(top: 9.adjustedH(),
                                                      left: 24.adjusted(),
                                                      bottom: 9.adjustedH(),
                                                      right: 24.adjusted()))
        label.text = "제작 완료"
        label.font = .Pretendard(size: 16, family: .SemiBold)
        label.setLineHeight(lineHeight: 140)
        label.textColor = .white
        label.backgroundColor = .init(hex: "141414", alpha: 0.5)
        label.layer.cornerRadius = 20.adjustedH()
        return label
    }()
    
    private let flowerImageStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 0
        view.distribution = .fillEqually
        return view
    }()
    
    private let saveAsImageSmallButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(hex: "F6F6F6", alpha: 0.8)
        config.baseForegroundColor = .gray09
        config.background.cornerRadius = 21
        config.attributedTitle = AttributedString("이미지로 저장", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.Pretendard(family: .SemiBold)]))
        config.image = .downloadIcon
        config.imagePadding = 4.adjusted()
        config.imagePlacement = .leading
        config.contentInsets = .init(top: 8.adjustedH(),
                                     leading: 20.adjusted(),
                                     bottom: 8.adjustedH(),
                                     trailing: 18.adjusted())
        
        button.configuration = config
        button.addTarget(self, action: #selector(saveAsImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let requestDetailView = RequestDetailView(requestDetailType: .myPage)
    
    private let saveAsImageButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor.customPrimary
        config.baseForegroundColor = .gray02
        config.attributedTitle = AttributedString("이미지로 저장하기", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.Pretendard(size: 16, family: .SemiBold)]))
        config.background.cornerRadius = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 17.adjustedH(),
                                                       leading: 0,
                                                       bottom: 17.adjustedH(),
                                                       trailing: 0)
        
        button.configuration = config
        button.addTarget(self, action: #selector(saveAsImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    init(with BouquetModel: BouquetModel) {
        viewModel = RequestDetailViewModel(requestTitle: BouquetModel.bouquetTitle, 
                                           bouquetId: BouquetModel.bouquetId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        delegate = self
        
        bind()
        setupNavigation()
        addViews()
        setupConstraints()
        viewModel.fetchBouquetDetail(bouquetId: viewModel.getBouquetId())
    }
    
    // MARK: - Functions
    
    private func setupNavigation() {
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = viewModel.getRequestTitle()
        self.navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.Pretendard(size: 18, family: .SemiBold)]
        
        let backbutton = UIBarButtonItem(image: UIImage.chevronLeft, style: .done, target: self, action: #selector(goBack))
        
        let moreActionButton = UIBarButtonItem(image: UIImage.moreIcon, style: .plain, target: self, action: #selector(showMoreActions))
        
        // left bar button을 추가하면 기존에 되던 스와이프 pop 기능이 해제됨
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        self.navigationItem.leftBarButtonItem = backbutton
        self.navigationItem.rightBarButtonItem = moreActionButton
    }
    
    private func addViews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(flowerImageStackView)
        contentView.addSubview(productionCompletedLabel)
        contentView.addSubview(saveAsImageSmallButton)
        contentView.addSubview(requestDetailView)
        contentView.addSubview(saveAsImageButton)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(4)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        productionCompletedLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24.adjustedH())
            make.leading.equalToSuperview().inset(20.adjusted())
        }
        
        flowerImageStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(flowerImageStackView.snp.width).multipliedBy(1)
        }
        
        saveAsImageSmallButton.snp.makeConstraints { make in
            make.bottom.equalTo(requestDetailView.snp.top).offset(-11.adjustedH())
            make.centerX.equalToSuperview()
        }
        
        requestDetailView.snp.makeConstraints { make in
            make.top.equalTo(flowerImageStackView.snp.bottom).inset(64.adjustedH())
            make.leading.trailing.equalToSuperview().inset(20.adjusted())
        }
        
        saveAsImageButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.adjusted())
            make.top.equalTo(requestDetailView.snp.bottom).offset(28.adjustedH())
            make.bottom.equalToSuperview().inset(10.adjustedH())
        }
    }
    
    /// 이미지 하단에 흰색 그라데이션 레이어 추가
    private func setImageViewGradientLayer() {
        let gradientLayer = CAGradientLayer()

        gradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.76, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1.0)
        
        gradientLayer.frame = flowerImageStackView.bounds
        
        flowerImageStackView.layer.addSublayer(gradientLayer)
    }
    
    private func configureFlowerImage(imageURLs: [String?]) {
        flowerImageStackView.removeArrangedSubviews()
        
        for imageURL in imageURLs {
            if let urlString = imageURL {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                flowerImageStackView.addArrangedSubview(imageView)
                
                if let url = URL(string: urlString) {
                    ImageProvider.shared.setImage(into: imageView, from: url.absoluteString)
                }
            }
        }
        
        setImageViewGradientLayer()
    }
    
    private func configureSaveAsImageSmallButton(isHidden: Bool) {
        saveAsImageSmallButton.isHidden = isHidden
    }
    
    private func configureProductionCompletedLabel(isHidden: Bool) {
        productionCompletedLabel.isHidden = isHidden
    }
    
    private func bind() {
        viewModel.requestDetailModelDidChange = { [weak self] model in
            guard let model = model else { return }
            DispatchQueue.main.async {
                self?.requestDetailView.config(model: model.customizingSummaryModel)
                
                // 사용자가 등록한 실제 꽃다발 사진이 있는 경우 해당 사진을 보여주도록
                if let realBouquetImage = model.bouquetRealImage {
                    self?.configureFlowerImage(imageURLs: [realBouquetImage])
                }
                else {
                    self?.configureFlowerImage(imageURLs: model.customizingSummaryModel.flowers.map({ $0.photo }))
                }
                self?.configureSaveAsImageSmallButton(isHidden: model.status == .producted ? true : false)
                self?.configureProductionCompletedLabel(isHidden: model.status == .producted ? false : true)
            }
        }
        
        viewModel.imageUploadSuccessDidChange = { [weak self] success in
            guard let success = success else { return }
            
            DispatchQueue.main.async {
                self?.showBouquetImageUploadSuccessAlert(success: success)
            }
        }
        
        viewModel.showError = { [weak self] error in
            self?.showAlert(title: "네트워킹 오류", message: error.localizedDescription)
        }
    }
    
    func showProductionSuccessAlert() {
        let alertVC = BouquetProductionSuccessAlertController()
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.delegate = self
        self.present(alertVC, animated: false, completion: nil)
    }
    
    private func showBouquetImageUploadSuccessAlert(success: Bool) {
        let alertViewController = BouquetImageUploadAlertConroller(uploadResult: success ? .success : .fail, from: self)
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        self.present(alertViewController, animated: true)
    }
    
    // MARK: - Actions
    
    @objc func saveAsImageButtonTapped() {
        ImageSaver().saveAsImage(requestDetailView.transfromToImage()!, target: self) {
            let requestTitle = self.viewModel.getRequestTitle()
            let customAlertVC = CustomAlertViewController(requestTitle: requestTitle, alertType: .requestSaveAlert, currentVC: self)
            customAlertVC.modalPresentationStyle = .overFullScreen
            self.present(customAlertVC, animated: false, completion: nil)
        }
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func showMoreActions() {
        let moreActionsSheetVC = MoreActionsSheetViewController(title: viewModel.getRequestTitle(),
                                                                bouquetId: viewModel.getBouquetId(),
                                                                isProducted: (viewModel.getRequestDetailModel().status == .producted) ? true : false,
                                                                requestDetail: viewModel.getRequestDetailModel().customizingSummaryModel,
                                                                from: self)
        
        moreActionsSheetVC.modalPresentationStyle = .pageSheet
        moreActionsSheetVC.bouquetProductionSuccessDelegate = self
        
        if let sheet = moreActionsSheetVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.selectedDetentIdentifier = .medium
            sheet.preferredCornerRadius = 20
        }
        
        present(moreActionsSheetVC, animated: true)
    }
}

// MARK: - Extension; ScrollView

extension RequestDetailViewController: UIScrollViewDelegate {
    
}

// MARK: - Extension; UIGestureRecognizer

extension RequestDetailViewController: UIGestureRecognizerDelegate {}

// MARK: - Extension;

extension RequestDetailViewController: BouquetProductionSuccessDelegate {
    func didSelectGoToGallery() {
        photoAuthService.requestAuthorization { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                let vc = PhotoViewController(photosCount: 0, photoSelectionLimitCount: 1)
                vc.modalPresentationStyle = .fullScreen
                vc.completionHandler = { [self] photos in
                    let photoDatas = photos.values.compactMap{ $0 }.compactMap{ $0.pngData() }
                    self.viewModel.postProductedBouquetImage(bouquetId: self.viewModel.getBouquetId(),
                                                             imageFile: ImageFile(filename: "RealBouquetImg",
                                                                                  data: photoDatas[0],
                                                                                  type: "image/png"))
                }
                present(vc, animated: true)
                
            case .failure:
                return
            }
        }
    }
}
