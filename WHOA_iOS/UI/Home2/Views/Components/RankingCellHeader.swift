//
//  RankingCellHeader.swift
//  WHOA_iOS
//
//  Created by 김세훈 on 1/13/25.
//

import UIKit

final class RankingCellHeader: UICollectionReusableView {

    // MARK: - Enums
    
    /// Attributes
    private enum Attributes {
        static let cheapRankingTitle = "이번 주 저렴한 꽃 랭킹"
        static let popularRankingTitle = "후아 인기 꽃 랭킹"
    }
    
    // MARK: - UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.customPrimary
        label.font = .Pretendard(size: 20, family: .Bold)
        return label
    }()
    
    private let baseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "4월 첫째 주 기준\n출처: 화훼유통정보시스템"
        label.textColor = UIColor.gray07
        label.font = .Pretendard(size: 12, family: .Regular)
        label.numberOfLines = 2
        label.textAlignment = .right
        return label
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
            titleLabel,
            baseDateLabel
        ].forEach(addSubview(_:))
    }
    
    private func setupUI() {
        backgroundColor = .white
    }
    
    func configure(for section: HomeSection) {
        switch section {
        case .cheapRanking:
            titleLabel.text = Attributes.cheapRankingTitle
            baseDateLabel.attributedText = makeBaseDateAttributedText(dateText: "", includeSource: true)
            
        case .popularRanking:
            titleLabel.text = Attributes.popularRankingTitle
            baseDateLabel.attributedText = makeBaseDateAttributedText(dateText: "", includeSource: false)
            
        default:
            break
        }
    }
    
    func setBaseDateLabel(dateText: String, includeSource: Bool = true) {
        baseDateLabel.attributedText = makeBaseDateAttributedText(dateText: dateText, includeSource: includeSource)
    }
    
    private func makeBaseDateAttributedText(dateText: String, includeSource: Bool = true) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = .right
        
        let finalText = includeSource ? dateText : dateText.replacingOccurrences(of: "\n출처: 화훼유통정보시스템", with: "")
        
        let attributedString = NSMutableAttributedString(
            string: finalText,
            attributes: [
                .font: UIFont.Pretendard(size: 12, family: .Regular),
                .foregroundColor: UIColor.gray07,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        if includeSource, let range = finalText.range(of: "출처: 화훼유통정보시스템") {
            attributedString.addAttributes([
                .font: UIFont.Pretendard(size: 10, family: .Light)
            ], range: NSRange(range, in: finalText))
        }
        
        return attributedString
    }
}

// MARK: - AutoLayout

extension RankingCellHeader {
    private func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        baseDateLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
        }
    }
}

