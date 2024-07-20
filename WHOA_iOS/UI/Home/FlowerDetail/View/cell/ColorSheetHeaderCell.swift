//
//  ColorSheetHeaderCell.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 4/4/24.
//

import UIKit

class ColorSheetHeaderCell: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "ColorSheetHeaderCell"
    
    // MARK: - Views
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 색으로 꾸며볼까요?"
        label.textColor = .primary
        label.font = .Pretendard(size: 20, family: .Bold)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func addViews() {
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
}
