//
//  CustomAlertViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/27/24.
//

import UIKit
import SnapKit

class CustomAlertViewController: UIViewController {
    // MARK: - AlertType
    enum AlertType: String {
        case modify = "수정"
        case delete = "삭제"
        case requestSaveAlert = "이미지가 저장되었습니다"
    }
    
    // MARK: - Properties
    private var requestTitle: String?
    private var alertType: AlertType?
    private var myPageVC: MyPageViewController?
    
    // MARK: - Views
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var titleLabel: UILabel = { [self] in
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        var fullTitle = ""
        
        // 이미지 저장 팝업인 경우만 attribute 필요 없음
        if alertType == .requestSaveAlert {
            label.text = alertType?.rawValue
        }
        else{
            fullTitle = "\(requestTitle!)을 \(alertType!.rawValue)할까요?"
            let attributedText = NSMutableAttributedString(string: fullTitle)
            let range = (fullTitle as NSString).range(of: requestTitle!)
            attributedText.addAttribute(.foregroundColor, value: UIColor(red: 6/255, green: 198/255, blue: 163/255, alpha: 1), range: range)  // secondary color
            label.attributedText = attributedText
        }
        print("---custom alert vc, titleLabel: \(fullTitle)")
        
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        
        if alertType == .delete {
            label.text = "삭제하면 복구할 수 없습니다."
        }
        
        else if alertType == .modify{
            label.text = "커스터마이징을 다시 시작합니다."
        }
        else {
            label.text = "요구서를 꽃집 사장님에게 전달해주세요."
        }
        
        label.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1) // gray02
        config.background.cornerRadius = 10
        config.attributedTitle = "아니요"
        config.attributedTitle?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        config.baseForegroundColor = UIColor(red: 102/255, green: 102/255, blue: 103/255, alpha: 1)  // gray08
        config.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 39, bottom: 13, trailing: 39)
        
        button.configuration = config
        button.addTarget(self, action: #selector(cancelBtnTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)  // primary
        config.background.cornerRadius = 10
        
        if alertType == .requestSaveAlert {
            config.attributedTitle = AttributedString("확인")
        }
        else{
            config.attributedTitle = AttributedString("\(alertType!.rawValue)할래요")
        }
        
        config.attributedTitle?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        config.baseForegroundColor = .white   // gray01
        config.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 41, bottom: 13, trailing: 41)
        
        button.configuration = config
        button.addTarget(self, action: #selector(confirmBtnTapped), for: .touchUpInside)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Initialization
    convenience init(requestTitle: String? = nil, alertType: AlertType, currentVC: UIViewController) {
        self.init()

        self.requestTitle = requestTitle
        self.alertType = alertType
        self.myPageVC = myPageVC
        print("---custom alert vc, requestTitle:\(requestTitle), alertType: \(alertType)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 0.5)  // primary color
        addViews()
        setupConstraints()
    }
    
    // MARK: - Helpers
    private func addViews(){
        view.addSubview(alertView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(descriptionLabel)
        alertView.addSubview(buttonStackView)
        
        if alertType != .requestSaveAlert {
            buttonStackView.addArrangedSubview(cancelButton)
        }
        buttonStackView.addArrangedSubview(confirmButton)
    }
    
    private func setupConstraints(){
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            //make.horizontalEdges.equalToSuperview().inset(50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(70)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(50)
//            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    // MARK: - Actions
    @objc func cancelBtnTapped(){
        print("===요구서 삭제/수정 취소===")
        dismiss(animated: false)
    }
    
    @objc func confirmBtnTapped(){
        print("===요구서 삭제/수정 확인===")
        dismiss(animated: false)
        
        if alertType == AlertType.modify {
            //TODO: 구매 목적 페이지로 이동..
            let buyingIntentVC = BuyingIntentViewController(viewModel: BuyingIntentViewModel())
            buyingIntentVC.modalPresentationStyle = .fullScreen
            
            myPageVC!.present(buyingIntentVC, animated: true)
        }
        else if alertType == .delete {
            // TODO: 요구서 삭제 api 요청
        }
    }
}
