//
//  SaveAlertViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 3/22/24.
//

import UIKit

enum SaveResult {
    case success
    case networkError
    case duplicateError
}

final class SaveAlertViewController: UIViewController {
    
    // MARK: - Properties
    
    private var saveResult: SaveResult
    var currentVC: UIViewController?
    
    // MARK: - UI
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 7.5
        return view
    }()
    
    private let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "SaveAlertFlower")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(size: 20, family: .Bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard()
        label.textColor = .gray06
        return label
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7.5
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(currentVC: UIViewController, saveResult: SaveResult) {
        self.currentVC = currentVC
        self.saveResult = saveResult
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
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .customPrimary.withAlphaComponent(0.5)
        
        view.addSubview(alertView)
        alertView.addSubview(flowerImageView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(descriptionLabel)
        alertView.addSubview(exitButton)
        
        setupAutoLayout()
    }
    
    private func configUI() {
        switch saveResult {
        case .success:
            flowerImageView.image = UIImage(named: "SaveSuccess")
            titleLabel.text = "저장 완료!"
            descriptionLabel.text = "꽃다발 요구서를 저장했어요."
            exitButton.setTitle("마이페이지 가기", for: .normal)
        case .networkError, .duplicateError:
            flowerImageView.image = UIImage(named: "SaveFailure")
            titleLabel.text = "저장 실패"
            descriptionLabel.text = "네트워크 연결 상태를 확인해 주세요."
            exitButton.setTitle("다시 시도하기", for: .normal)
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func exitButtonTapped() {
        switch saveResult {
        case .success:
            dismiss(animated: true) { [weak self] in
                BouquetDataManager.shared.reset()
                self?.currentVC?.tabBarController?.selectedIndex = 2
                self?.currentVC?.navigationController?.popToRootViewController(animated: true)
            }
        case .networkError, .duplicateError:
            dismiss(animated: true)
        }
    }
}

extension SaveAlertViewController {
    private func setupAutoLayout() {
        alertView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(350)
            $0.height.equalTo(288)
        }
        
        flowerImageView.snp.makeConstraints {
            $0.top.equalTo(alertView).offset(45)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(flowerImageView.snp.bottom).offset(15.66)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        exitButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().offset(-24)
        }
    }
}
