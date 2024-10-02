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
    
    private let madeCompleteLabel: HashTagCustomLabel = {
        let label = HashTagCustomLabel(padding: .init(top: 9.adjustedH(basedOnHeight: 844),
                                                      left: 24.adjusted(basedOnWidth: 390),
                                                      bottom: 9.adjustedH(basedOnHeight: 844),
                                                      right: 24.adjusted(basedOnWidth: 390)))
        label.text = "제작 완료"
        label.font = .Pretendard(size: 16, family: .SemiBold)
        label.setLineHeight(lineHeight: 140)
        label.textColor = .white
        label.backgroundColor = .init(hex: "141414", alpha: 0.5)
        label.layer.cornerRadius = 20.adjustedH(basedOnHeight: 844)
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
        config.imagePadding = 4.adjusted(basedOnWidth: 390)
        config.imagePlacement = .leading
        config.contentInsets = .init(top: 8.adjustedH(basedOnHeight: 844),
                                     leading: 20.adjusted(basedOnWidth: 390),
                                     bottom: 8.adjustedH(basedOnHeight: 844),
                                     trailing: 18.adjusted(basedOnWidth: 390))
        
        button.configuration = config
        button.addTarget(self, action: #selector(saveAsImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let requestDetailView = RequestDetailView(requestDetailType: .myPage)
    
    private let saveAsImageButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor.primary
        config.baseForegroundColor = UIColor(red: 249/255, green: 249/255, blue: 251/255, alpha: 1)
        config.attributedTitle = AttributedString("이미지로 저장하기", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.Pretendard(size: 16, family: .SemiBold)]))
        config.background.cornerRadius = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 17.adjustedH(basedOnHeight: 844),
                                                       leading: 0,
                                                       bottom: 17.adjustedH(basedOnHeight: 844),
                                                       trailing: 0)
        
        button.configuration = config
        button.addTarget(self, action: #selector(saveAsImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    init(with BouquetModel: BouquetModel) {
        viewModel = RequestDetailViewModel(requestTitle: BouquetModel.bouquetTitle, bouquetId: BouquetModel.bouquetId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
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
        contentView.addSubview(madeCompleteLabel)
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
        
        madeCompleteLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24.adjustedH(basedOnHeight: 844))
            make.leading.equalToSuperview().inset(20.adjusted(basedOnWidth: 390))
        }
        
        flowerImageStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(flowerImageStackView.snp.width).multipliedBy(1)
        }
        
        saveAsImageSmallButton.snp.makeConstraints { make in
            make.bottom.equalTo(requestDetailView.snp.top).offset(-11.adjustedH(basedOnHeight: 844))
            make.centerX.equalToSuperview()
        }
        
        requestDetailView.snp.makeConstraints { make in
            make.top.equalTo(flowerImageStackView.snp.bottom).inset(64.adjustedH(basedOnHeight: 844))
            make.leading.trailing.equalToSuperview().inset(20.adjusted(basedOnWidth: 390))
        }
        
        saveAsImageButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20.adjusted(basedOnWidth: 390))
            make.top.equalTo(requestDetailView.snp.bottom).offset(28.adjustedH(basedOnHeight: 844))
            make.bottom.equalToSuperview().inset(10.adjustedH(basedOnHeight: 844))
        }
    }
    
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
    
    private func configureMadeCompleteLabel(isHidden: Bool) {
        madeCompleteLabel.isHidden = isHidden
    }
    
    private func bind() {
        viewModel.customizingSummaryModelDidChaged = { [weak self] model in
            guard let model = model else { return }
            DispatchQueue.main.async {
                self?.requestDetailView.config(model: model)
                self?.configureFlowerImage(imageURLs: model.flowers.map({ $0.photo }))
                self?.configureSaveAsImageSmallButton(isHidden: false)
                self?.configureMadeCompleteLabel(isHidden: false)
            }
        }
        
        viewModel.showError = { [weak self] error in
            self?.showAlert(title: "네트워킹 오류", message: error.localizedDescription)
        }
    }
    
    func showMadeSuccessAlert() {
        let alertVC = RequestMadeSuccessAlertController()
        alertVC.modalPresentationStyle = .overFullScreen
        self.present(alertVC, animated: false, completion: nil)
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
        print("케밥 버튼 선택됨")
        
        let moreActionsSheetVC = MoreActionsSheetViewController(title: viewModel.getRequestTitle(), 
                                                                bouquetId: viewModel.getBouquetId(),
                                                                from: self)
        
        moreActionsSheetVC.modalPresentationStyle = .pageSheet
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
