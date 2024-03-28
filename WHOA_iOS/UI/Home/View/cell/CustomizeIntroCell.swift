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
    let customizeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        return stackView
    }()
    
    let customizeLabel: UILabel = {
        let label = UILabel()
        label.text = "커스터마이징 탭"
        label.font = UIFont(name: "Pretendard-Bold", size: 14)
        label.textColor = UIColor(named: "Secondary03")
        return label
    }()
    
    let bouqetWithWhoaLabel: UILabel = {
        let label = UILabel()
        label.text = "WHOA로 만드는\n나만의 꽃다발"
        label.numberOfLines = 2
        label.font = UIFont(name: "Pretendard-Bold", size: 24)
        label.textColor = UIColor(named: "Gray01")
        label.setLineSpacing(spacing: 5)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃말을 담아 내 마음을 전해보세요"
        label.font = UIFont(name: "Pretendard-Medium", size: 14)
        label.textColor = UIColor(named: "Gray05")
        return label
    }()
    
//    private let customizeIntroHashTagLabel: HashTagCustomLabel = {
//        let label = HashTagCustomLabel()
//        label.text = "커스터마이징 탭"
//        label.font = UIFont(name: "Pretendard-SemiBold", size: 12)
//        label.textColor = UIColor(named: "Secondary05")
//        label.backgroundColor = UIColor(named: "Secondary03")
//        return label
//    }()
//    
//    private let customYoursLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 2
//        label.text = "나만의 꽃다발을\n커스터마이징 해보세요!"
//        label.font = UIFont(name: "Pretendard-Bold", size: 20)
//        label.setLineSpacing(spacing: 5)
//        return label
//    }()
    
//    private let customizeDescriptionLabel: UILabel = {
//        let label = UILabel()
//        label.text = "의미를 담은 특별한 꽃다발을 원한다면\n꽃다발 커스터마이징 서비스가 있어요.\n상황과 꽃말에 따라 개성 넘치는 꽃다발\n을 제작해 보세요!"
//        label.numberOfLines = 4
//        label.font = UIFont(name: "Pretendard-Regular", size: 14)
//        label.textColor = UIColor(named: "Primary")
//        label.setLineSpacing(spacing: 5)
//        return label
//    }()
    
    let flowerDecoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "FlowerDeco")
        return imageView
    }()
    
    let customizeButton: CustomButton = {
        let button = CustomButton(buttonType: .customizing)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(named: "Gray09")
        self.layer.borderColor = UIColor(named: "Primary")?.cgColor
        self.layer.borderWidth = 1
        
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func addViews(){
        addSubview(customizeStackView)
//        addSubview(flowerDecoImageView)
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
        }
        
//        flowerDecoImageView.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(18)
//            make.trailing.equalToSuperview().inset(11.5)
//            make.leading.equalTo(customizeStackView.snp.trailing).offset(15)
//        }
    }
}
