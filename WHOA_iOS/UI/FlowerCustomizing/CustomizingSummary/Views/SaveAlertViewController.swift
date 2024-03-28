//
//  SaveAlertViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 3/22/24.
//

import UIKit

class SaveAlertViewController: UIViewController {
    
    // MARK: - Properties
    
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
        label.text = "저장 완료!"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃다발 요구서를 저장했어요."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("마이페이지 가기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7.5
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = UIColor.clear
        
        view.addSubview(alertView)
        alertView.addSubview(flowerImageView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(descriptionLabel)
        alertView.addSubview(exitButton)
        
        setupAutoLayout()
    }
    
    // MARK: - Actions
    
    @objc
    private func exitButtonTapped() {
        let homeVC = HomeViewController()
        
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true)
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