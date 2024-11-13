//
//  RequirementTextView.swift
//  WHOA_iOS
//
//  Created by KSH on 11/13/24.
//

import UIKit
import Combine

final class RequirementTextView: UIView {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let placeholderOffset = 20.0
    }
    
    /// Attributes
    private enum Attributes {
        static let placeholder = "요구사항을 작성해주세요."
    }
    
    // MARK: - Properties
    
    private let textView: UITextView = {
        let view = UITextView()
        view.font = .Pretendard()
        view.textColor = .black
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray04.cgColor
        view.textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
//        view.isHidden = true
        //        view.delegate = self
        return view
    }()
    
    private let placeholder: UILabel = {
        let label = UILabel()
        label.text = Attributes.placeholder
        label.textColor = .gray06
        label.font = .Pretendard()
        return label
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        addSubview(textView)
        textView.addSubview(placeholder)
        setupAutoLayout()
    }
}

// MARK: - AutoLayout

extension RequirementTextView {
    private func setupAutoLayout() {
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        placeholder.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(Metric.placeholderOffset)
        }
    }
}
