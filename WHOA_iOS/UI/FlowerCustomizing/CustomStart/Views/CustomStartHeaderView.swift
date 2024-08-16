//
//  CustomStartHeaderView.swift
//  WHOA_iOS
//
//  Created by KSH on 8/15/24.
//

import UIKit

final class CustomStartHeaderView: UIView {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        let text = "꽃다발 커스터마이징으로\n나만의 꽃다발을 만들어보세요"
        let font = UIFont.Pretendard(size: 24, family: .SemiBold)
        let attributedStr = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: UIColor.black
            ]
        )
        
        let targetText = "나만의 꽃다발"
        if let range = text.range(of: targetText) {
            let nsRange = NSRange(range, in: text)
            attributedStr.addAttribute(.foregroundColor, value: UIColor.white, range: nsRange)
        }
        
        label.attributedText = attributedStr
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "의미가 가득담긴\n꽃다발을 만들 수 있도록 도와드려요!"
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
            $0.top.equalToSuperview().offset(41)
            $0.leading.equalToSuperview().offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        bouquetImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(70)
        }
    }
}
