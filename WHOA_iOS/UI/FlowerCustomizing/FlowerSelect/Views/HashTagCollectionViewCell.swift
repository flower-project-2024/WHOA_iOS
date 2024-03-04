//
//  HashTagCollectionViewCell.swift
//  WHOA_iOS
//
//  Created by KSH on 2/28/24.
//

import UIKit

final class HashTagCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - UI
    
    let hashTagTitle: UILabel = {
        let label = UILabel()
        label.text = "전체"
        label.font = UIFont(name: "Pretendard-Regular", size: 18)
        label.textColor = UIColor.systemGray2
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
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 20
        
        addSubview(hashTagTitle)
        
        setupAutoLayout()
    }
    
    func setupHashTag(text: String) {
        hashTagTitle.text = text
    }
}

extension HashTagCollectionViewCell {
    private func setupAutoLayout() {
        hashTagTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
