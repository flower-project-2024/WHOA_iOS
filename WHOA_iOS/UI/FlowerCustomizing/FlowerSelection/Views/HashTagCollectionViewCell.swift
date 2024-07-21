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
        label.font = .Pretendard()
        label.textColor = .gray08
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
        contentView.layer.cornerRadius = 18
        contentView.layer.borderColor = UIColor.gray04.cgColor
        contentView.layer.borderWidth = 1
        
        addSubview(hashTagTitle)
        
        setupAutoLayout()
    }
    
    func setupHashTag(text: String) {
        hashTagTitle.text = text
    }
    
    private func updateAppearance() {
        contentView.layer.borderColor = isSelected ? UIColor.secondary03.cgColor : UIColor.gray04.cgColor
        hashTagTitle.font = isSelected ? .Pretendard(family: .SemiBold) : .Pretendard()
        hashTagTitle.textColor = isSelected ? .primary : .gray08
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
