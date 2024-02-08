//
//  CheapFlowerInfoCell.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/8/24.
//

import UIKit

class CheapFlowerInfoCell: UITableViewCell {
    // MARK: - Properties
    
    static let identifier = "CheapFlowerInfoCell"
        
    // MARK: - Views
    let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    let rankingLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.text = "1"
        return label
    }()
    
    let flowerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20)
        label.text = "히아신스"
        return label
    }()
    
    let flowerLanguageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.text = "영원한 사랑"
        label.textColor = .darkGray
        return label
    }()
    
    let priceChangeRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 14)
        label.text = "-58%"
        label.textColor = .darkGray
        return label
    }()
    
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - functions
    private func setupConstraints(){
        // add view
        contentView.addSubview(flowerImageView)
        contentView.addSubview(rankingLabel)
        contentView.addSubview(flowerNameLabel)
        contentView.addSubview(flowerLanguageLabel)
        contentView.addSubview(priceChangeRateLabel)
        
        // constraints
        flowerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(60)  // 1:1 비율
            make.bottom.equalToSuperview().inset(10)
        }
        
        rankingLabel.snp.makeConstraints { make in
            make.leading.equalTo(flowerImageView.snp.trailing).offset(25)
            make.centerY.equalTo(flowerImageView)
        }
        
        flowerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(rankingLabel.snp.top)
            make.leading.equalTo(rankingLabel.snp.trailing).offset(25)
            make.centerY.equalTo(rankingLabel)
        }
        
        flowerLanguageLabel.snp.makeConstraints { make in
            make.leading.equalTo(flowerNameLabel.snp.leading)
            make.top.equalTo(flowerNameLabel.snp.bottom)
        }
        
        priceChangeRateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(flowerImageView)
        }
    }
    
}
