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
    
    var flowerId: Int?
        
    // MARK: - Views
    
    private let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.appLogo
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = CGColor(red: 199/255, green: 199/255, blue: 199/255, alpha: 1)
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    let rankingLabel: UILabel =  {
        let label = UILabel()
        label.font = .Pretendard(size: 20, family: .SemiBold)
        label.textColor = UIColor.primary
        label.text = "1"
        return label
    }()
    
    private let flowerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(size: 16, family: .SemiBold)
        label.textColor = UIColor.primary
        label.text = "히아신스"
        return label
    }()
    
    private let flowerLanguageLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(size: 12, family: .Medium)
        label.text = "영원한 사랑"
        label.textColor = UIColor.gray07
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(family: .Bold)
        label.text = "2100원"
        label.textColor = UIColor.secondary04
        return label
    }()
    
    private let moveToDetailImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.chevronRight.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = UIColor.gray07
        return imageView
    }()
    
    // MARK: - Initialziation
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
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
    
    func configure(model: CheapFlowerModel) {
        flowerNameLabel.text = model.flowerRankingName
        flowerLanguageLabel.text = model.flowerRankingLanguage ?? "꽃말 정보 없음"
        priceLabel.text = "\(model.flowerRankingPrice)원"
        
        // 서버에 있는 꽃인 경우
        if let id = model.flowerId {
            self.flowerId = id
            moveToDetailImageView.isHidden = false
            if let img = model.flowerRankingImg {
                flowerImageView.load(url: URL(string: img)!)
            }
        }
        // 서버에 없는 꽃인 경우
        else{
            moveToDetailImageView.isHidden = true
            flowerImageView.image = UIImage.appLogo
        }
    }
}
