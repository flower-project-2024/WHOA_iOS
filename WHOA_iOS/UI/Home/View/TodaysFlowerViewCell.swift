//
//  TodaysFlowerViewCell.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/15/24.
//

import UIKit

class TodaysFlowerViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "TodaysFlowerViewCell"
    
    // MARK: - Views
    let todaysFlowerLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 추천 꽃"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20.0)
        return label
    }()
    
    let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    let flowerDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        return view
    }()
    
    let flowerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "히아신스"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 20.0)
        return label
    }()
    
    let birthFlowerLabel: HashTagCustomLabel = {
        let label = HashTagCustomLabel()
        label.text = "8/15 탄생화"
        label.font = UIFont(name: "Pretendard-Regular", size: 14.0)
        return label
    }()
    
    let flowerDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "무게감 있는 진한 향이 오래도록 퍼져나가, 영원한 사랑을 전하기에 제격이에요."
        label.numberOfLines = 0
        label.font = UIFont(name: "Pretendard-Regular", size: 14.0)
        return label
    }()
    
    let flowerLanguageLabel: HashTagCustomLabel = {
        let label = HashTagCustomLabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14.0)
        label.text = "영원한 사랑"
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.clipsToBounds = true
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .white
        stackView.layer.borderColor = CGColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
        stackView.layer.borderWidth = 1
        return stackView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .lightGray
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func addViews(){
        addSubview(todaysFlowerLabel)
        addSubview(stackView)

        flowerDescriptionView.addSubview(flowerNameLabel)
        flowerDescriptionView.addSubview(birthFlowerLabel)
        flowerDescriptionView.addSubview(flowerDescriptionLabel)
        flowerDescriptionView.addSubview(flowerLanguageLabel)

        stackView.addArrangedSubview(flowerImageView)
        stackView.addArrangedSubview(flowerDescriptionView)
    }
    
    private func setupConstraints(){
        todaysFlowerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(todaysFlowerLabel.snp.bottom).offset(17)
            make.bottom.equalToSuperview()
        }

        flowerImageView.snp.makeConstraints { make in
            make.height.equalTo(140)
            make.width.equalTo(flowerImageView.snp.height).multipliedBy(3.0 / 4.0)
        }

        flowerNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
        }

        birthFlowerLabel.snp.makeConstraints { make in
            make.leading.equalTo(flowerNameLabel.snp.trailing).offset(20)
            make.centerY.equalTo(flowerNameLabel.snp.centerY)
        }

        flowerDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(flowerNameLabel)
            make.top.equalTo(flowerNameLabel.snp.bottom).offset(8.25)
            make.trailing.equalToSuperview().inset(20)
        }

        flowerLanguageLabel.snp.makeConstraints { make in
            make.leading.equalTo(flowerDescriptionLabel)
            make.top.equalTo(flowerDescriptionLabel.snp.bottom).offset(8.25)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
