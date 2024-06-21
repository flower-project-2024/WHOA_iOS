//
//  FlowerLanguageCell.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 6/22/24.
//

import UIKit

class FlowerLanguageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "FlowerLanguageCell"
    
    // MARK: - Views
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .Pretendard()  // 기본 세팅 - regular, 14
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = false
        contentView.backgroundColor = UIColor.gray03
        
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func addViews(){
        contentView.addSubview(label)
    }
    
    private func setupConstraints(){
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview().inset(12)
        }
    }
    
    func configure(_ data: String) {
        label.text = data
    }
    
    func getLabelFrame() -> CGRect {
        return label.frame
    }
}
