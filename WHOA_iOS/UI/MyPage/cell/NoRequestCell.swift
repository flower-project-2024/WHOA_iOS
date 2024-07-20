//
//  NoRequestCell.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 7/12/24.
//

import UIKit

final class NoRequestCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "NoRequestCell"
    
    // MARK: - Views
    
    private let noRequestImageView: UIImageView = {
        let view = UIImageView()
        view.image = .noSearchResultIcon
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "저장된 요구서가 없어요."
        label.font = .Pretendard(size: 16, family: .Bold)
        label.textColor = .primary
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃다발 커스터마이징으로 요구서를 만들어보세요!"
        label.font = .Pretendard()
        label.textColor = .gray07
        label.textAlignment = .center
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
    
    // MARK: - Functions
    
    private func addViews() {
        contentView.addSubview(noRequestImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        noRequestImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(noRequestImageView.snp.bottom).offset(19)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

