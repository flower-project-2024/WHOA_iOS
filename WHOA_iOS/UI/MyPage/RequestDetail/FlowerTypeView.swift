//
//  FlowerTypeView.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/5/24.
//

import UIKit

/**
 * 요구서 > 꽃 종류 (꽃 이미지, 꽃 이름, 꽃말)
 */
class FlowerTypeView: UIView {
    
    // MARK: - Views
    let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "WhoaLogo")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = UIColor(red: 233/255, green: 233/255, blue: 235/255, alpha: 1).cgColor  // gray04
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let flowerInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    let flowerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "과꽃"
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        return label
    }()
    
    private let flowerLanguageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        return stackView
    }()
    
    let flowerLanguageTagLabel1: DetailCustomLabel = {
        let label = DetailCustomLabel()
        label.text = "믿는 사랑"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)  // gray03
        return label
    }()
    
    let flowerLanguageTagLabel2: DetailCustomLabel = {
        let label = DetailCustomLabel()
        label.text = "추억"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)  // gray03
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func addViews(){
        self.addSubview(flowerImageView)
        self.addSubview(flowerInfoStackView)
        
        flowerInfoStackView.addArrangedSubview(flowerNameLabel)
        flowerInfoStackView.addArrangedSubview(flowerLanguageStackView)
        
        flowerLanguageStackView.addArrangedSubview(flowerLanguageTagLabel1)
        flowerLanguageStackView.addArrangedSubview(flowerLanguageTagLabel2)
    }
    
    private func setupConstraints(){
        flowerImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(64)
            make.width.equalTo(flowerImageView.snp.height).multipliedBy(1)
        }
        
        flowerInfoStackView.snp.makeConstraints { make in
            make.centerY.equalTo(flowerImageView.snp.centerY)
            make.leading.equalTo(flowerImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
