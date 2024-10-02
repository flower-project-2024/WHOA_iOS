//
//  CustomStartHeaderView.swift
//  WHOA_iOS
//
//  Created by KSH on 8/15/24.
//

import UIKit

final class CustomStartHeaderView: UIView {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let titleLabelTopOffset = 39.0
        static let titleLabelLeadingOffset = 20.0
        static let descriptionLabelTopOffset = 10.0
    }
    
    /// Attributes
    private enum Attributes {
        static let titleLabelText = "꽃다발 커스터마이징으로\n나만의 꽃다발을 만들어보세요"
        static let descriptionLabelText = "의미가 가득담긴 꽃다발을\n만들 수 있도록 도와드려요!"
    }
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Attributes.titleLabelText
        label.font = UIFont.Pretendard(size: 24, family: .Bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Attributes.descriptionLabelText
        label.textColor = .gray09
        label.font = .Pretendard(size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let bouquetImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bouquet
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initialize
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .secondary03
        
        [
            titleLabel,
            descriptionLabel,
            bouquetImageView
        ].forEach(addSubview(_:))
        
        setupAutoLayout()
    }
    
}

// MARK: - AutoLayout

extension CustomStartHeaderView {
    private func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Metric.titleLabelTopOffset)
            $0.leading.equalToSuperview().offset(Metric.titleLabelLeadingOffset)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Metric.descriptionLabelTopOffset)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        bouquetImageView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
