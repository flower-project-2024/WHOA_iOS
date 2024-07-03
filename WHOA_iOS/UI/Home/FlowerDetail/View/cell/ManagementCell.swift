//
//  ManagementCell.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/25/24.
//

import UIKit

class ManagementCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ManagementColletionViewCell"
    
    // MARK: - Views
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.watering
        return imageView
    }()
    
    private lazy var managementTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "탈수 잦음"
        label.font = .Pretendard(size: 16, family: .Bold)
        label.textColor = UIColor.secondary05
        return label
    }()
    
    private lazy var managementContentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .Pretendard(size: 16, family: .Regular)
        label.lineBreakStrategy = .hangulWordPriority
        label.textColor = UIColor.gray09
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        contentView.backgroundColor = .white
        
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = false
        
        contentView.layer.borderColor = UIColor.gray03.cgColor
        contentView.layer.borderWidth = 1
                
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.prepare(image: nil)
    }
    
    // MARK: - Helpers
    
    func prepare(image: UIImage?) {
      self.imageView.image = image
    }
    
    func configure(content: [String]){
        managementTitleLabel.text = content[0]
        managementContentLabel.text = content[1]
        managementContentLabel.setLineHeight(lineHeight: 142)
    }
    
    private func addViews(){
        contentView.addSubview(imageView)
        contentView.addSubview(managementTitleLabel)
        contentView.addSubview(managementContentLabel)
    }
    
    private func setupConstraints(){
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.centerX.equalToSuperview()
            make.height.equalTo(99)
        }
        
        managementTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(22)
            make.top.equalTo(imageView.snp.bottom).offset(15)
        }
        
        managementContentLabel.snp.makeConstraints { make in
            make.leading.equalTo(managementTitleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(22)
            make.top.equalTo(managementTitleLabel.snp.bottom).offset(6)
//            make.bottom.equalToSuperview().inset(22)
        }
    }
}
