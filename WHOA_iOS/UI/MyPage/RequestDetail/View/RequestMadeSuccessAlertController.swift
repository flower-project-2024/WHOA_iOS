//
//  RequestMadeSuccessAlertController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 9/7/24.
//

import UIKit
import SnapKit

class RequestMadeSuccessAlertController: UIViewController {
    
    // MARK: - Views
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.madeCompleteIllust
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃다발을 제작했나요?"
        label.font = .Pretendard()
        label.textColor = .init(hex: "757575")
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃다발 사진을 기록해보세요."
        label.font = .Pretendard(size: 20, family: .Bold)
        return label
    }()
    
    private let noButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor.gray02
        config.background.cornerRadius = 10
        config.attributedTitle = "안할래요"
        config.attributedTitle?.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        config.baseForegroundColor = UIColor.gray08
        config.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 30, bottom: 13, trailing: 30)
        
        button.configuration = config
        button.addTarget(self, action: #selector(noButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var chooseFromGalleryButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor.primary // primary
        config.background.cornerRadius = 10
        config.attributedTitle = "갤러리에서 선택"
        config.attributedTitle?.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 36, bottom: 13, trailing: 36)
        
        button.configuration = config
        button.addTarget(self, action: #selector(chooseFromGalleryButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primary.withAlphaComponent(0.5)
        
        addViews()
        setupConstraints()
    }
    
    // MARK: - Actions
    
    @objc private func noButtonDidTap() {
        dismiss(animated: false)
    }
    
    @objc private func chooseFromGalleryButtonDidTap() {
        print("갤러리에서 선택하기")
    }
    
    // MARK: - Functions
    
    private func addViews() {
        view.addSubview(alertView)
        alertView.addSubview(imageView)
        alertView.addSubview(subtitleLabel)
        alertView.addSubview(titleLabel)
        alertView.addSubview(buttonStackView)
        
        [noButton, chooseFromGalleryButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(42)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(21)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(24)
        }
    }
}
