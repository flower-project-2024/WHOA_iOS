//
//  SearchBarView.swift
//  WHOA_iOS
//
//  Created by KSH on 12/12/24.
//

import UIKit
import Combine
import SnapKit

final class SearchBarCell: UICollectionViewCell {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let titleLabelLeadingOffset = 29.0
        static let magnifyingglassViewTrailingOffset = -15.0
    }
    
    /// Attributes
    private enum Attributes {
        static let titleLabelText = "어떤 꽃을 찾으시나요?"
        static let searchIcon = "SearchIcon"
    }
    
    // MARK: - Properties
    
    private let searchBarTapSubject = PassthroughSubject<Void, Never>()
    var cancellables = Set<AnyCancellable>()
    
    var searchBarTapPublisher: AnyPublisher<Void, Never> {
        searchBarTapSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Attributes.titleLabelText
        label.font = .Pretendard()
        label.textColor = .gray07
        return label
    }()
    
    private let magnifyingglassView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Attributes.searchIcon)
        return imageView
    }()
    
    // MARK: - initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupAutoLayout()
        setupUI()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func addSubviews() {
        [
            titleLabel,
            magnifyingglassView
        ].forEach(addSubview(_:))
    }
    
    private func setupUI() {
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray04.cgColor
        backgroundColor = .gray03
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchBar))
        addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func didTapSearchBar() {
        searchBarTapSubject.send()
    }
}

// MARK: - AutoLayout

extension SearchBarCell {
    private func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Metric.titleLabelLeadingOffset)
        }
        
        magnifyingglassView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(Metric.magnifyingglassViewTrailingOffset)
        }
    }
}
