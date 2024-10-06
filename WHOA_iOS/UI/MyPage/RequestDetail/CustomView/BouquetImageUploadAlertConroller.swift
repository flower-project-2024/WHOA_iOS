//
//  BouquetImageUploadAlertConroller.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 10/5/24.
//

import UIKit

enum UploadResultType {
    case success
    case fail
}

final class BouquetImageUploadAlertConroller: UIViewController {
    
    // MARK: - Properties
    
    private let uploadResult: UploadResultType
    private let currentVC: UIViewController
    
    // MARK: - Views
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .saveSuccess
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Pretendard(size: 20, family: .Bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Pretendard()
        label.textColor = .init(hex: "757575")
        label.setLineHeight(lineHeight: 140)
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor.primary
        config.background.cornerRadius = 10
        config.attributedTitle?.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 13, leading: 41, bottom: 13, trailing: 41)
        
        button.configuration = config
        button.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(uploadResult: UploadResultType, from currentVC: UIViewController) {
        self.uploadResult = uploadResult
        self.currentVC = currentVC
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primary.withAlphaComponent(0.5)
        
        addViews()
        setupConstraints()
        configUI()
    }
    
    // MARK: - Actions
    
    @objc private func confirmButtonDidTap() {
        print("=== 버튼 선택됨 ====")
        switch uploadResult {
        case .success:
            print("upload success!")
            dismiss(animated: true) { [weak self] in
                self?.currentVC.navigationController?.popViewController(animated: true)
            }
            
        case .fail:
            print("upload fail!")
            dismiss(animated: true)
        }
    }
    
    // MARK: - Functions
    
    private func addViews() {
        view.addSubview(alertView)
        
        alertView.addSubview(imageView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(descriptionLabel)
        alertView.addSubview(confirmButton)
    }
    
    private func setupConstraints() {
        alertView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20.adjusted())
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(45.adjustedH())
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(15.66.adjustedH())
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(8.adjustedH())
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(24.adjustedH())
            make.horizontalEdges.equalToSuperview().inset(24.adjusted())
            make.bottom.equalToSuperview().inset(24.adjustedH())
        }
    }
    
    private func configUI() {
        switch uploadResult {
        case .success:
            imageView.image = .saveSuccess
            titleLabel.text = "등록 완료"
            descriptionLabel.text = "꽃다발 사진을 등록했어요."
            confirmButton.configuration?.attributedTitle = "확인"
            confirmButton.configuration?.attributedTitle?.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        case .fail:
            imageView.image = .saveFailure
            titleLabel.text = "등록 실패"
            descriptionLabel.text = "네트워크 연결 상태를 확인해 주세요."
            confirmButton.configuration?.attributedTitle = "다시 시도하기"
            confirmButton.configuration?.attributedTitle?.font = UIFont.Pretendard(size: 16, family: .SemiBold)
        }
    }
}
