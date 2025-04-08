//
//  CustomAlertViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/27/24.
//

import UIKit
import SnapKit

protocol CustomAlertViewControllerDelegate: AnyObject {
    func deleteSuccessful(bouquetId: Int)
    func renameSuccessful(bouquetId: Int, newName: String)
}

final class CustomAlertViewController: UIViewController {
    
    // MARK: - AlertType
    
    enum AlertType: String {
        case modify = "수정"
        case delete = "삭제"
        case requestSaveAlert = "요구서가 갤러리에 저장되었습니다"
        case renameRequestAlert = ""
    }
    
    // MARK: - Properties
    
    private var requestTitle: String
    private var alertType: AlertType
    private var myPageVC: UIViewController?
    private var dataManager: BouquetDataManaging
    var bouquetId: Int?
    
    var customizingCoordinator: CustomizingCoordinator?
    weak var delegate: CustomAlertViewControllerDelegate?
    
    // MARK: - Views
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var titleLabel: UILabel = { [self] in
        let label = UILabel()
        label.font = UIFont.Pretendard(size: 20, family: .Bold)
        var fullTitle = ""
        
        // 이미지 저장 팝업인 경우만 attribute 필요 없음
        if alertType == .requestSaveAlert {
            label.text = alertType.rawValue
        }
        
        else if alertType == .renameRequestAlert {
            label.text = "꽃다발 요구서 이름을 수정하세요."
        }
        
        else {
            fullTitle = "\(requestTitle)을 \(alertType.rawValue)할까요?"
            let attributedText = NSMutableAttributedString(string: fullTitle)
            let range = (fullTitle as NSString).range(of: requestTitle)
            attributedText.addAttribute(.foregroundColor, value: UIColor.secondary04, range: range)
            label.attributedText = attributedText
        }
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Pretendard(size: 14, family: .Regular)
        
        if alertType == .delete {
            label.isHidden = false
            label.text = "삭제하면 복구할 수 없습니다."
        }
        
        else if alertType == .modify {
            label.isHidden = false
            label.text = "커스터마이징을 다시 시작합니다."
        }
        
        else if alertType == .renameRequestAlert {
            label.isHidden = true
        }
        
        label.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = .Pretendard(size: 16)
        textField.textColor = .black
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray04.cgColor
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 8.0
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.attributedPlaceholder = NSAttributedString(
            string: "엄마생신 꽃다발",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.gray05,
                NSAttributedString.Key.font : UIFont.Pretendard()
            ]
        )
        return textField
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor.gray02
        config.background.cornerRadius = 10
        config.attributedTitle = "아니요"
        config.attributedTitle?.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        config.baseForegroundColor = UIColor.gray08
        config.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 39, bottom: 13, trailing: 39)
        
        button.configuration = config
        button.addTarget(self, action: #selector(cancelBtnTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor.customPrimary
        config.background.cornerRadius = 10
        
        if alertType == .requestSaveAlert {
            config.attributedTitle = AttributedString("확인")
        } else if alertType == .renameRequestAlert {
            config.attributedTitle = AttributedString("수정할래요")
        } else {
            config.attributedTitle = AttributedString("\(alertType.rawValue)할래요")
        }
        
        config.attributedTitle?.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        config.baseForegroundColor = .white
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
    
    // MARK: - Init
    
    init(requestTitle: String,
         alertType: AlertType,
         currentVC: UIViewController,
         dataManager: BouquetDataManaging = BouquetDataManager.shared) {
        self.requestTitle = requestTitle
        self.alertType = alertType
        self.myPageVC = currentVC
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.customPrimary.withAlphaComponent(0.5)
        
        addViews()
        setupConstraints()
        textField.delegate = self
    }
    
    // MARK: - Functions
    
    private func addViews() {
        view.addSubview(alertView)
        alertView.addSubview(titleLabel)
        
        if alertType == .renameRequestAlert {
            alertView.addSubview(textField)
        } else {
            alertView.addSubview(descriptionLabel)
        }
        
        alertView.addSubview(buttonStackView)
        
        if alertType != .requestSaveAlert {
            buttonStackView.addArrangedSubview(cancelButton)
        }
        buttonStackView.addArrangedSubview(confirmButton)
    }
    
    private func setupConstraints() {
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(70)
        }
        
        if alertType == .renameRequestAlert {
            textField.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(16)
                make.centerX.equalToSuperview()
                make.horizontalEdges.equalToSuperview().inset(24)
                make.height.equalTo(40)
            }
            
            buttonStackView.snp.makeConstraints { make in
                make.top.equalTo(textField.snp.bottom).offset(30)
                make.leading.trailing.equalToSuperview().inset(24)
                make.bottom.equalToSuperview().inset(24)
            }
        } else {
            descriptionLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
            }
            
            buttonStackView.snp.makeConstraints { make in
                make.top.equalTo(descriptionLabel.snp.bottom).offset(50)
                make.leading.trailing.equalToSuperview().inset(24)
                make.bottom.equalToSuperview().inset(24)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func cancelBtnTapped() {
        dismiss(animated: false)
    }
    
    @objc func confirmBtnTapped() {
        if alertType == AlertType.modify {
            guard let bouquetId = bouquetId else { return }
            fetchBouquetDetail(requestTitle: requestTitle, bouquetId: bouquetId)
            dismiss(animated: true) { [weak self] in
                self?.dataManager.setActionType(.update(bouquetId: bouquetId))
                self?.myPageVC?.tabBarController?.selectedIndex = 1
                self?.customizingCoordinator?.showPurposeVC()
            }

        }
        else if alertType == .delete {
            guard
                let id = KeychainManager.shared.loadMemberId(),
                let bouquetId = bouquetId
            else { return }
            
            NetworkManager.shared.deleteBouquet(memberID: id, bouquetId: bouquetId) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.dismiss(animated: false) {
                            self.delegate?.deleteSuccessful(bouquetId: bouquetId)
                        }
                    }
                case .failure(let error):
                    self.showAlert(title: "네트워킹 오류", message: error.localizedDescription)
                }
            }
        }
        
        else if alertType == .renameRequestAlert {
            guard let bouquetId = bouquetId,
                  let memberID = KeychainManager.shared.loadMemberId() else { return }
            guard let newName = textField.text, !newName.isEmpty else {
                showAlert(title: "오류", message: "새로운 제목을 입력해주세요.")
                return
            }
            NetworkManager.shared.bouquetRename(
                bouquetId: bouquetId,
                memberID: memberID,
                bouquetName: newName
            ) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self?.dismiss(animated: true) {
                            self?.delegate?.renameSuccessful(bouquetId: bouquetId, newName: newName)
                        }
                    case .failure(let error):
                        self?.showAlert(title: "네트워킹 오류", message: error.localizedDescription)
                    }
                }
            }
        }
            
        else if alertType == .requestSaveAlert {
            dismiss(animated: true)
        }
    }
    
    func fetchBouquetDetail(requestTitle: String, bouquetId: Int) {
        guard let id = KeychainManager.shared.loadMemberId() else { return }
        NetworkManager.shared.fetchBouquetDetail(memberID: id, bouquetId: bouquetId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let dto):
                BouquetDetailDTO.saveBouquetData(
                    requestTitle: requestTitle,
                    dto: dto,
                    dataManager: self.dataManager
                )
            case .failure(let error):
                self.showAlert(title: "네트워킹 오류", message: error.localizedDescription)
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension CustomAlertViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
