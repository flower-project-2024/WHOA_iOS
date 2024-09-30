//
//  CheapFlowerInfoCell.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/8/24.
//

import UIKit

final class CheapFlowerInfoCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CheapFlowerInfoCell"
    
    var flowerId: Int?
    
    private var flowerLanguage: String?
        
    // MARK: - Views
    
    private let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = CGColor(red: 199/255, green: 199/255, blue: 199/255, alpha: 1)
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    let rankingLabel: UILabel =  {
        let label = UILabel()
        label.font = .Pretendard(size: 20, family: .Medium)
        label.textColor = UIColor.primary
        return label
    }()
    
    let flowerInfoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 6
        view.alignment = .leading
        return view
    }()
    
    private let flowerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(size: 16, family: .SemiBold)
        label.textColor = UIColor.primary
        return label
    }()
    
    private let flowerLanguageStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 0
        return view
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(family: .Bold)
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
    
    // MARK: - Init
    
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
        contentView.addSubview(flowerImageView)
        contentView.addSubview(rankingLabel)
        contentView.addSubview(flowerInfoStackView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(moveToDetailImageView)
        
        [flowerNameLabel, flowerLanguageStackView].forEach {
            flowerInfoStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        flowerImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview()
            make.height.equalTo(flowerImageView.snp.width).multipliedBy(1)  // 1:1 비율
        }
        
        rankingLabel.snp.makeConstraints { make in
            make.leading.equalTo(flowerImageView.snp.trailing).offset(17)
            make.top.equalTo(flowerNameLabel.snp.top)
        }
        
        flowerInfoStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(rankingLabel.snp.trailing).offset(17)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(flowerInfoStackView.snp.trailing)
            make.centerY.equalTo(flowerNameLabel.snp.centerY)
        }
        
        moveToDetailImageView.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(3)
            make.centerY.equalTo(priceLabel.snp.centerY)
        }
    }
    
    func configure(model: CheapFlowerModel) {
        flowerNameLabel.text = model.flowerRankingName
        
        priceLabel.text = "\(model.flowerRankingPrice.formatNumberInThousands())원"
        
        // DB에 있는 꽃일 경우
        if let id = model.flowerId {
            self.flowerId = id
            moveToDetailImageView.isHidden = false
            
            if let img = model.flowerRankingImg {
                ImageProvider.shared.setImage(into: flowerImageView, from: img)
            }
            else {
                flowerImageView.image = .defaultFlower
            }
        }
        // DB에 없는 꽃일 경우
        else {
            let illustArray = [UIImage.flowerIllust1,
                               UIImage.flowerIllust2,
                               UIImage.flowerIllust3,
                               UIImage.flowerIllust4]
            
            moveToDetailImageView.isHidden = true
            flowerImageView.image = illustArray.randomElement()
        }
        
        flowerLanguage = model.flowerRankingLanguage
    }
    
    func updateFlowerLanguageStackView() {
        flowerLanguageStackView.removeArrangedSubviews()
                
        if let language = self.flowerLanguage {
            
            var languageList = language.split(separator: ",").map({
                String($0).trimmingCharacters(in: .whitespaces)
            })
            
            for i in 1 ..< languageList.count {
                languageList[i] =  "," + languageList[i]
            }
                
            let languageLabelList: [UILabel] = languageList.map {
                let label = UILabel()
                label.text = $0
                label.font = .Pretendard(size: 12, family: .Regular)
                label.textColor = UIColor.gray07
                label.sizeToFit()
                return label
            }

            let stackViewWidth = self.flowerInfoStackView.bounds.width
            
            var widthSum: CGFloat = 0
            for label in languageLabelList {
                if label.frame.width + widthSum <= stackViewWidth {
                    widthSum += label.frame.width
                    flowerLanguageStackView.addArrangedSubview(label)
                }
                else {
                    return
                }
            }
        }
        else {
            let label = UILabel()
            label.text = "꽃말 정보 없음"
            label.font = .Pretendard(size: 12, family: .Regular)
            label.textColor = UIColor.gray07
            label.sizeToFit()
            flowerLanguageStackView.addArrangedSubview(label)
        }
    }
}
