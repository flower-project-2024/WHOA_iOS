//
//  CustomAlertViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/10/24.
//

import UIKit
import SnapKit

class CustomExitAlertViewController: UIViewController {
    
    // MARK: - Properties
    
    var currentVC: UIViewController
    
    // MARK: - UI
    
    private let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 7.5
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "커스트마이징을 종료할까요?"
        label.font = .systemFont(ofSize: 13.5)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "페이지를 나가면 복구할 수 없습니다,"
        label.font = .systemFont(ofSize: 9)
        label.textColor = .lightGray
        return label
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("종료하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7.5
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("계속하기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
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
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 9
        return stackView
    }()
    
    init(currentVC: UIViewController) {
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
        view.backgroundColor = UIColor.clear
        
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
            self?.currentVC.tabBarController?.selectedIndex = 0
            self?.currentVC.navigationController?.popToRootViewController(animated: true)
            
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
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(262.5)
            $0.height.equalTo(180)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(45.75)
            $0.leading.equalToSuperview().offset(56.25)
            $0.trailing.equalToSuperview().offset(-55.5)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp_bottomMargin).offset(15)
            $0.leading.equalToSuperview().offset(67.5)
            $0.trailing.equalToSuperview().offset(66.75)
        }
        
        continueButton.snp.makeConstraints {
            $0.width.equalTo(130.5)
            $0.height.equalTo(36)
        }
        
        buttonHStackView.snp.makeConstraints {
            $0.leading.equalTo(18)
            $0.trailing.equalTo(-18)
            $0.bottom.equalTo(-25.5)
        }
    }
}
