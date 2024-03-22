//
//  CustomSummaryView.swift
//  WHOA_iOS
//
//  Created by KSH on 3/21/24.
//

import UIKit

class CustomSummaryView: UIView {
    
    // MARK: - Properties
    
    // MARK: - UI
    
    private let requestNameTextField: UITextField = {
        let textField = UITextField()
        textField.frame.size.height = 40
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 6
        textField.layer.masksToBounds = true
        textField.isEnabled = false
        return textField
    }()
    
    private let requestNameTextFieldPlaceholder: UILabel = {
        let label = UILabel()
        label.text = "꽃다발 요구서1"
        label.textColor = .systemGray  // Gray08
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Edit"), for: .normal)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let borderLine: UIView = {
        let view = BorderLine()
        view.backgroundColor = .black
        return view
    }()
    
    private let requestDetailView = RequestDetailView()
    
    // MARK: Initializer
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        addSubview(requestNameTextField)
        requestNameTextField.addSubview(requestNameTextFieldPlaceholder)
        addSubview(editButton)
        
        addSubview(borderLine)
        addSubview(requestDetailView)
        
        setupAutoLayout()
    }
    
    // MARK: - Actions
    
    @objc
    private func editButtonTapped() {
        requestNameTextField.isEnabled = true
        requestNameTextFieldPlaceholder.isHidden = true
    }
}

extension CustomSummaryView {
    private func setupAutoLayout() {
        requestNameTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        requestNameTextFieldPlaceholder.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(12)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(requestNameTextField.snp.centerY)
            $0.trailing.equalTo(requestNameTextField.snp.trailing).offset(-12)
        }
        
        borderLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(requestNameTextField.snp.bottom).offset(16)
            $0.height.equalTo(1)
        }
        
        requestDetailView.snp.makeConstraints {
            $0.top.equalTo(requestNameTextField.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
