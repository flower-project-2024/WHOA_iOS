//
//  RankingCell.swift
//  WHOA_iOS
//
//  Created by 김세훈 on 1/13/25.
//

import UIKit

final class RankingCell: UICollectionViewCell {
    
    // MARK: - Enums
    
    /// Metric
    private enum Metric {
        static let flowerImageViewHeightMultiplier: CGFloat = 1.0
        static let rankingLabelTopOffset: CGFloat = 12.0
        static let elementLeadingOffset: CGFloat = 17.0
        static let priceInfoHStackViewTrailingOffset: CGFloat = -4.0
    }
    
    // MARK: - UI
    
    private let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .flowerIllust1
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = UIColor.gray06.cgColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    private let rankingLabel: UILabel =  {
        let label = UILabel()
        label.text = "1"
        label.font = .Pretendard(size: 20, family: .Medium)
        label.textColor = .customPrimary
        return label
    }()
    
    private let flowerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "히아신스"
        label.font = .Pretendard(size: 16, family: .SemiBold)
        label.textColor = UIColor.customPrimary
        return label
    }()
    
    private let flowerLanguageLabel: UILabel =  {
        let label = UILabel()
        label.text = "영원한 사랑"
        label.font = .Pretendard(size: 12, family: .Regular)
        label.textColor = .gray07
        return label
    }()
    
    private lazy var textVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            flowerNameLabel,
            flowerLanguageLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "2,100"
        label.font = .Pretendard(family: .Bold)
        label.textColor = UIColor.secondary04
        return label
    }()
    
    private let moveToDetailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.chevronRight.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.gray07
        return imageView
    }()
    
    private lazy var priceInfoHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            priceLabel,
            moveToDetailImageView
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupAutoLayout()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func addSubviews() {
        [
            flowerImageView,
            rankingLabel,
            textVStackView,
            priceInfoHStackView
        ].forEach(addSubview(_:))
    }
    
    private func setupUI() {
        backgroundColor = .white
    }
}

// MARK: - AutoLayout

extension RankingCell {
    private func setupAutoLayout() {
        flowerImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(flowerImageView.snp.height).multipliedBy(Metric.flowerImageViewHeightMultiplier)
        }
        
        rankingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Metric.rankingLabelTopOffset)
            $0.leading.equalTo(flowerImageView.snp.trailing).offset(Metric.elementLeadingOffset)
        }
        
        textVStackView.snp.makeConstraints {
            $0.top.equalTo(rankingLabel.snp.top)
            $0.leading.equalTo(rankingLabel.snp.trailing).offset(Metric.elementLeadingOffset)
        }
        
        priceInfoHStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(Metric.priceInfoHStackViewTrailingOffset)
        }
    }
}
