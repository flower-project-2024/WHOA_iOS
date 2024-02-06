//
//  TodaysFlowerView.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/6/24.
//

import UIKit
import SnapKit

class TodaysFlowerView: UIView {
    // MARK: - Views
    
    let todaysFlowerLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 추천 꽃"
        label.font = UIFont(name: "Pretendard-Bold", size: 24.0)
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
    
    let flowerDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "무게감 있는 진한 향이 오래도록 퍼져나가, 영원한 사랑을 전하기에 제격이에요."
        label.numberOfLines = 0
        label.font = UIFont(name: "Pretendard-Regular", size: 14.0)
        return label
    }()
    
    let flowerLanguageLabel: FlowerLanguageLabel = {
        let label = FlowerLanguageLabel()
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
        label.backgroundColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.00)
        label.font = UIFont(name: "Pretendard-Regular", size: 14.0)
        label.text = "영원한 사랑"
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 10
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.layer.borderColor = CGColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
        stackView.layer.borderWidth = 1
        return stackView;
    }()
    
    let decorateButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.title = "이 꽃으로 꾸미기"
        config.attributedTitle?.font = UIFont(name: "Pretendard-Bold", size: 20.0)
        config.background.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1.00)
        config.background.cornerRadius = 10
        config.contentInsets = .init(top: 15, leading: 15, bottom: 15, trailing: 15)
        button.configuration = config
        return button
    }()
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // add ui elements
        addSubview(todaysFlowerLabel)
        addSubview(stackView)
        addSubview(decorateButton)
        
        flowerDescriptionView.addSubview(flowerNameLabel)
        flowerDescriptionView.addSubview(flowerDescriptionLabel)
        flowerDescriptionView.addSubview(flowerLanguageLabel)
        
        stackView.addArrangedSubview(flowerImageView)
        stackView.addArrangedSubview(flowerDescriptionView)
    
        
        // constraints
        todaysFlowerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
         
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(todaysFlowerLabel.snp.bottom).offset(17)
        }
        
        flowerImageView.snp.makeConstraints { make in
            make.height.equalTo(140)
            make.width.equalTo(flowerImageView.snp.height).multipliedBy(3.0 / 4.0)
        }
        
        flowerNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
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
        
        decorateButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(17)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
