//
//  CustomHeaderView.swift
//  WHOA_iOS
//
//  Created by KSH on 7/27/24.
//

import UIKit
import Combine

final class CustomHeaderView: UIView {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let exitButtonTopOffset = 17.0
        static let progressViewTopOffset = 25.0
        static let progressViewHeight = 12.75
        static let titleLabelTopOffset = 24.0
        static let descriptionLabelTopOffset = 12.0
    }
    
    // MARK: - Properties
    
    private let exitButtonTappedSubject = PassthroughSubject<Void, Never>()
    
    var exitButtonTappedPublisher: AnyPublisher<Void, Never> {
        exitButtonTappedSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UI
    
    private lazy var exitButton: UIImageView = {
        let button = UIImageView()
        button.image = .xmark
        button.tintColor = .black
        button.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(exitButtonTapped))
        button.addGestureRecognizer(tapGesture)
        return button
    }()
    
    private let progressHStackView: CustomProgressHStackView
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(size: 24, family: .SemiBold)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(size: 16, family: .SemiBold)
        label.textColor = .gray07
        label.numberOfLines = 2
        label.isHidden = true
        return label
    }()
    
    // MARK: - Initialize
    
    init(
        numerator: Float,
        title: String,
        description: String? = nil
    ) {
        self.progressHStackView = CustomProgressHStackView(numerator: numerator, denominator: 7)
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        backgroundColor = .white
        descriptionLabel.isHidden = (descriptionLabel.text == nil)
        [
            exitButton,
            progressHStackView,
            titleLabel,
            descriptionLabel
        ].forEach(addSubview(_:))
        setupAutoLayout()
    }
    
    // MARK: - Actions
    
    @objc
    private func exitButtonTapped() {
        exitButtonTappedSubject.send()
    }
}

// MARK: - AutoLayout

extension CustomHeaderView {
    private func setupAutoLayout() {
        exitButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Metric.exitButtonTopOffset)
            $0.leading.equalToSuperview()
        }
        
        progressHStackView.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).offset(Metric.progressViewTopOffset)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Metric.progressViewHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressHStackView.snp.bottom).offset(Metric.titleLabelTopOffset)
            $0.leading.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Metric.descriptionLabelTopOffset)
            $0.leading.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().priority(.low)
        }
    }
}
