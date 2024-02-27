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
    
    private let hashTagButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.systemMint.cgColor
        button.layer.borderWidth = 1
        return button
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
        addSubview(hashTagButton)
        
        setupAutoLayout()
    }
    
    func setupHashTag(text: String) {
        hashTagButton.setTitle(text, for: .normal)
    }
}

extension HashTagCollectionViewCell {
    private func setupAutoLayout() {
        hashTagButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(48)
        }
    }
}
