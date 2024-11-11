//
//  KeywordHScrollView.swift
//  WHOA_iOS
//
//  Created by KSH on 2/28/24.
//

import UIKit
import Combine

final class KeywordHScrollView: UIView {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let sideMargin = 20.0
    }
    
    // MARK: - Properties
    
    private let keywordSubject = PassthroughSubject<KeywordType, Never>()
    
    var valuePublisher: AnyPublisher<KeywordType, Never> {
        return keywordSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UI
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        buildKeywordButtons(with: KeywordType.allCases)
        selectInitKeyword()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        setupAutoLayout()
    }
    
    private func selectInitKeyword() {
        if let allButton = stackView.arrangedSubviews.first as? UIButton {
            updateButtonStyle(allButton)
            keywordSubject.send(.all)
        }
    }
    
    func buildKeywordButtons(with keywords: [KeywordType]) {
        for i in 0..<keywords.count {
            let button = UIButton(type: .system)
            button.setTitle(keywords[i].rawValue, for: .normal)
            button.setTitleColor(.gray08, for: .normal)
            button.titleLabel?.font = .Pretendard(size: 14)
            button.layer.borderColor = UIColor.gray04.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 18
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
            button.addAction(UIAction(handler: { [weak self] _ in
                self?.keywordButtonTapped(button)
            }), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Actions

    private func keywordButtonTapped(_ sender: UIButton) {
        guard let keywordString = sender.titleLabel?.text else { return }
        resetButtons()
        updateButtonStyle(sender)
        keywordSubject.send(KeywordType(rawValue: keywordString) ?? .all)
    }
    
    private func resetButtons() {
        for view in stackView.arrangedSubviews {
            if let button = view as? UIButton {
                button.layer.borderColor = UIColor.gray04.cgColor
                button.setTitleColor(.gray08, for: .normal)
                button.titleLabel?.font = UIFont.Pretendard(size: 14)
            }
        }
    }
    
    private func updateButtonStyle(_ button: UIButton) {
        button.layer.borderColor = UIColor.secondary03.cgColor
        button.setTitleColor(.primary, for: .normal)
        button.titleLabel?.font = .Pretendard(size: 14, family: .SemiBold)
    }
}

// MARK: - AutoLayout

extension KeywordHScrollView {
    private func setupAutoLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.height.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
        }
    }
}
