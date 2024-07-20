//
//  NoSearchResultCell.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/22/24.
//

import UIKit
import SnapKit

class NoSearchResultCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "NoSearchResultCell"
    
    // MARK: - Views
    
    private let noResultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.noSearchResultIcon
        return imageView
    }()
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과가 없어요"
        label.textColor = UIColor.primary
        label.font = .Pretendard(size: 16, family: .Bold)
        return label
    }()
    
    private let tryAgainLabel: UILabel = {
        let label = UILabel()
        label.text = "다른 이름으로 검색해보세요."
        label.textColor = UIColor.primary
        label.font = .Pretendard(family: .Regular)
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   // MARK: - Helpers
    
    private func addViews() {
        addSubview(noResultImageView)
        addSubview(noResultLabel)
        addSubview(tryAgainLabel)
    }
    
    private func setupConstraints() {
        noResultImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(150)
            make.top.equalToSuperview().inset(40)
            make.height.equalTo(noResultImageView.snp.width).multipliedBy(1)
        }
        
        noResultLabel.snp.makeConstraints { make in
            make.top.equalTo(noResultImageView.snp.bottom).offset(19)
            make.centerX.equalToSuperview()
        }
        
        tryAgainLabel.snp.makeConstraints { make in
            make.top.equalTo(noResultLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
}
