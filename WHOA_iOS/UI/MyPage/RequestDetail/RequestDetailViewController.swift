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
    
    private let requestDetailView = RequestDetailView(requestDetailType: .myPage)
    
    private let saveAsImageButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor.primary
        config.baseForegroundColor = UIColor(red: 249/255, green: 249/255, blue: 251/255, alpha: 1)
        config.attributedTitle = AttributedString("이미지로 저장하기", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.Pretendard(size: 16, family: .SemiBold)]))
        config.background.cornerRadius = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 0, bottom: 17, trailing: 0)
        
        button.configuration = config
        button.addTarget(self, action: #selector(saveAsImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
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
    
    // MARK: - Helpers
    private func setupNavigation(){
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = viewModel.getRequestTitle()
        self.navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.Pretendard(size: 18, family: .SemiBold)]
        
        let backbutton = UIBarButtonItem(image: UIImage.chevronLeft, style: .done, target: self, action: #selector(goBack))
        
        // left bar button을 추가하면 기존에 되던 스와이프 pop 기능이 해제됨
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        self.navigationItem.leftBarButtonItem = backbutton
    }
    
    private func addViews(){
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(requestDetailView)
        
        contentView.addSubview(saveAsImageButton)
    }
    
    private func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(4)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
//            make.height.equalToSuperview()
        }
        
        requestDetailView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        saveAsImageButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(requestDetailView.snp.bottom).offset(28)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func bind() {
        viewModel.customizingSummaryModelDidChaged = { [weak self] model in
            guard let model = model else { return
            }
            DispatchQueue.main.async {
                self?.requestDetailView.config(model: model)
            }
        }
        
        viewModel.showError = { [weak self] error in
            print("showError")
            DispatchQueue.main.async {
                self?.fetchFailure(error)
            }
        }
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
    
    // MARK: - Actions
    
    @objc func saveAsImageButtonTapped(){
        ImageSaver().saveAsImage(requestDetailView.transfromToImage()!, target: self) {
            let requestTitle = self.viewModel.getRequestTitle()
            let customAlertVC = CustomAlertViewController(requestTitle: requestTitle, alertType: .requestSaveAlert, currentVC: self)
            customAlertVC.modalPresentationStyle = .overFullScreen
            self.present(customAlertVC, animated: false, completion: nil)
        }
    }
    
    @objc func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extension; ScrollView
extension RequestDetailViewController: UIScrollViewDelegate {
    
}

// MARK: - Extension; UIGestureRecognizer
extension RequestDetailViewController: UIGestureRecognizerDelegate {}
