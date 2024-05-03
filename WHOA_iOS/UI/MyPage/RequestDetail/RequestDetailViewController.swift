//
//  RequestDetailViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/4/24.
//

import UIKit

class RequestDetailViewController: UIViewController {
    // MARK: - Properties
    private var requestTitle: String!
    var myPageVC: MyPageViewController?
//    private var viewModel: RequestDetailViewModel!
    
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
    
    private let requestDetailView = RequestDetailView()
    
    private let saveAsImageButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)  // primary
        config.baseForegroundColor = UIColor(red: 249/255, green: 249/255, blue: 251/255, alpha: 1)
        config.attributedTitle = AttributedString("이미지로 저장하기", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont(name: "Pretendard-SemiBold", size: 16)!]))
        config.background.cornerRadius = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 17, leading: 117.5, bottom: 17, trailing: 117.5)
        
        button.configuration = config
        button.addTarget(self, action: #selector(saveAsImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    init(requestTitle: String!) {
        super.init(nibName: nil, bundle: nil)
        
        self.requestTitle = requestTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigation()
        addViews()
        setupConstraints()
    }
    
    // MARK: - Helpers
    private func setupNavigation(){
        navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = requestTitle
        self.navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "Pretendard-SemiBold", size: 18)!]
        
        //TODO: xmark -> chevron right으로 수정해야 함!
        let backbutton = UIBarButtonItem(image: UIImage(named: "xmark"), style: .done, target: self, action: #selector(goBack))
        
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
    
    // MARK: - Actions
    
    @objc func saveAsImageButtonTapped(){
        ImageSaver().saveAsImage(requestDetailView.transfromToImage()!, target: self) {
            let customAlertVC = CustomAlertViewController(requestTitle: self.requestTitle, alertType: .requestSaveAlert, currentVC: self)
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
