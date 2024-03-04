//
//  flowerSelectTableViewCell.swift
//  WHOA_iOS
//
//  Created by KSH on 2/28/24.
//

import UIKit

class FlowerSelectTableViewCell: UITableViewCell {
    
    // MARK: - UI
    
    private let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TempFlower")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let flowerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "튤립"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    
    private let addImageButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.app")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let hashTag: UILabel = {
        let label = UILabel()
        label.text = "믿는 사랑"
        label.textColor = .systemMint
//        label.backgroundColor = UIColor(red: 079/255, green: 234/255, blue: 191/255, alpha: 0.2)
        return label
    }()
    
    private let hashTag2: UILabel = {
        let label = UILabel()
        label.text = "추억"
        label.textColor = .systemMint
//        label.backgroundColor = UIColor(red: 079/255, green: 234/255, blue: 191/255, alpha: 0.2)
        return label
    }()
    
    private lazy var hashTagHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            hashTag,
            hashTag2
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .trailing
        stackView.spacing = 4
        return stackView
    }()
    
    private let flowerDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(
            red: 248/255,
            green: 248/255,
            blue: 248/255,
            alpha: 1.0
        )
        return view
    }()
    
    private lazy var fullHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            flowerImageView,
            flowerDescriptionView
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 12
        return stackView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0))
    }
    
    // MARK: - Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        contentView.addSubview(flowerDescriptionView)
        flowerDescriptionView.addSubview(flowerNameLabel)
        flowerDescriptionView.addSubview(addImageButton)
        flowerDescriptionView.addSubview(hashTagHStackView)
        
        contentView.addSubview(fullHStackView)
        
        setupAutoLayout()
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
    }
}

extension FlowerSelectTableViewCell {
    private func setupAutoLayout() {
        
        flowerImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(148)
        }
        
        flowerNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(60)
        }
        
        addImageButton.snp.makeConstraints {
            $0.centerY.equalTo(flowerNameLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(15)
            $0.size.equalTo(18)
        }
        
        hashTagHStackView.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(12)
        }
        
        fullHStackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
