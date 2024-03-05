//
//  HashTagCollectionViewCell.swift
//  WHOA_iOS
//
//  Created by KSH on 2/28/24.
//

import UIKit

final class HashTagCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    override var isSelected: Bool {
            didSet {
                updateAppearance()
            }
        }
    
    // MARK: - UI
    
    let hashTagTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
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
    
    private func updateAppearance() {
        hashTagTitle.font = isSelected ? UIFont(name: "Pretendard-SemiBold", size: 16) : UIFont(name: "Pretendard-Regular", size: 16)
        hashTagTitle.textColor = isSelected ? .black : .systemGray2
        contentView.layer.borderColor = isSelected ? UIColor.systemMint.cgColor : UIColor.systemGray5.cgColor
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
