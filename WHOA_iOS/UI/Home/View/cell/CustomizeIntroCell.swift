//
//  AppInfoCell.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/24/24.
//

import UIKit
import SnapKit

class CustomizeIntroCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "AppInfoCell"
    
    // MARK: - Views
    
    private let customizeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        return stackView
    }()
    
    private let customizeLabel: UILabel = {
        let label = UILabel()
        label.text = "커스터마이징 탭"
        label.font = .Pretendard(family: .Bold)
        label.textColor = UIColor.secondary03
        return label
    }()
    
    private let bouqetWithWhoaLabel: UILabel = {
        let label = UILabel()
        label.text = "WHOA로 만드는\n나만의 꽃다발"
        label.numberOfLines = 2
        label.font = .Pretendard(size: 24, family: .Bold)
        label.textColor = UIColor.gray01
        label.setLineHeight(lineHeight: 140)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃말을 담아 내 마음을 전해보세요"
        label.font = .Pretendard(family: .Medium)
        label.textColor = UIColor.gray05
        return label
    }()
    
    private let flowerDecoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.homeIllust
        return imageView
    }()
    
    private let customizeButton: CustomButton = {
        let button = CustomButton(buttonType: .customizing)
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.gray09
        self.layer.borderColor = UIColor.primary.cgColor
        self.layer.borderWidth = 1
        
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func addViews(){
        addSubview(customizeStackView)
        addSubview(flowerDecoImageView)
        addSubview(customizeButton)
        
        [customizeLabel, bouqetWithWhoaLabel, descriptionLabel].forEach {
            customizeStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints(){
        customizeStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(26)
        }
        
        customizeButton.snp.makeConstraints { make in
            make.leading.equalTo(customizeStackView.snp.leading)
            make.top.equalTo(customizeStackView.snp.bottom).offset(23)
            make.trailing.equalTo(flowerDecoImageView.snp.leading).inset(28)
        }
        
        flowerDecoImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo((flowerDecoImageView.image?.size.width)!)
        }
    }
}
