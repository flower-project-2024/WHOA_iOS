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
        imageView.image = UIImage(named: "FlowerImage.png")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = CGColor(red: 199/255, green: 199/255, blue: 199/255, alpha: 1)
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
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        label.text = "히아신스"
        return label
    }()
    
    let flowerLanguageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.text = "영원한 사랑"
        label.textColor = UIColor(named: "Gray07")
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Bold", size: 14)
        label.text = "2100원"
        label.textColor = UIColor(named: "Secondary04")
        return label
    }()
    
    let moveToDetailImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "ChevronRight")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = UIColor(named: "Gray07")
        return imageView
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
        contentView.addSubview(priceLabel)
        contentView.addSubview(moveToDetailImageView)
        
        // constraints
        flowerImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview()
            make.height.equalTo(flowerImageView.snp.width).multipliedBy(1)  // 1:1 비율
        }
        
        rankingLabel.snp.makeConstraints { make in
            make.leading.equalTo(flowerImageView.snp.trailing).offset(15)
            make.top.equalTo(flowerImageView.snp.top).inset(11.5)
        }
        
        flowerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(rankingLabel.snp.top)
            make.leading.equalTo(rankingLabel.snp.trailing).offset(25)
        }
        
        flowerLanguageLabel.snp.makeConstraints { make in
            make.leading.equalTo(flowerNameLabel.snp.leading)
            make.top.equalTo(flowerNameLabel.snp.bottom).offset(6)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(flowerImageView.snp.centerY)
        }
        
        moveToDetailImageView.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(3)
            make.centerY.equalTo(priceLabel.snp.centerY)
        }
    }
    
}
