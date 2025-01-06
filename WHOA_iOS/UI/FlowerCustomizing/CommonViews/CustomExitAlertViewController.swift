//
//  CustomAlertViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/10/24.
//

import UIKit
import SnapKit

final class CustomExitAlertViewController: UIViewController {
    
    // MARK: - Properties
    
    var currentVC: UIViewController?
    
    // MARK: - UI
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "커스터마이징을 종료할까요?"
        label.textColor = .black
        label.font = .Pretendard(size: 20, family: .Bold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "페이지를 나가면 복구할 수 없습니다."
        label.font = .Pretendard()
        label.textColor = .gray07
        return label
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("종료할래요", for: .normal)
        button.titleLabel?.font = .Pretendard(size: 16, family: .SemiBold)
        button.backgroundColor = .gray02
        button.setTitleColor(.gray08, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7.5
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("아니요", for: .normal)
        button.titleLabel?.font = .Pretendard(size: 16, family: .SemiBold)
        button.backgroundColor = .black
        button.clipsToBounds = true
        button.layer.cornerRadius = 7.5
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            exitButton,
            continueButton
        ].forEach { stackView.addArrangedSubview($0) }
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    init(currentVC: UIViewController?) {
        self.currentVC = currentVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .customPrimary.withAlphaComponent(0.5)
        
        view.addSubview(alertView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(descriptionLabel)
        alertView.addSubview(buttonHStackView)
        setupAutoLayout()
    }
    
    // MARK: - Actions
    
    @objc
    private func exitButtonTapped() {
        dismiss(animated: true) { [weak self] in
            BouquetDataManager.shared.reset()
            self?.currentVC?.tabBarController?.selectedIndex = 0
            if let navigationController = self?.currentVC?.navigationController {
                navigationController.popToRootViewController(animated: false)
            }
        }
    }
    
    @objc
    private func continueButtonTapped() {
        dismiss(animated: false)
    }
}

extension CustomExitAlertViewController {
    private func setupAutoLayout() {
        alertView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(302)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.55)
            $0.height.equalTo(48)
        }
        
        buttonHStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalTo(-24)
        }
    }
}
