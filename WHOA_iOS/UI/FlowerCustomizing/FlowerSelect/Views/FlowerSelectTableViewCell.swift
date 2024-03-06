//
//  flowerSelectTableViewCell.swift
//  WHOA_iOS
//
//  Created by KSH on 2/28/24.
//

import UIKit

class FlowerSelectTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var addImageButtonClicked: (() -> Void)?
    var isAddImageButtonSelected: Bool = false {
        didSet {
            updateAppearance(isAddImageButtonSelected)
        }
    }
    
    // MARK: - UI
    
    let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TempFlower")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let flowerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "튤립"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        return label
    }()
    
    lazy var addImageButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.app")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addImageButtonTapped))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private let hashTag: tempHashTagLabel = {
        let hashTagLabel = tempHashTagLabel(padding: UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10))
        hashTagLabel.text = "믿는 사랑"
        hashTagLabel.font = UIFont(name: "Pretendard-Medium", size: 14)
        hashTagLabel.textColor = .systemMint
        hashTagLabel.backgroundColor = UIColor(red: 079/255, green: 234/255, blue: 191/255, alpha: 0.2)
        return hashTagLabel
    }()
    
    private let hashTag2: tempHashTagLabel = {
        let hashTagLabel = tempHashTagLabel(padding: UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10))
        hashTagLabel.text = "추억"
        hashTagLabel.font = UIFont(name: "Pretendard-Medium", size: 14)
        hashTagLabel.textColor = .systemMint
        hashTagLabel.backgroundColor = UIColor(red: 079/255, green: 234/255, blue: 191/255, alpha: 0.2)
        return hashTagLabel
    }()
    
    private lazy var hashTagHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            hashTag,
            hashTag2
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
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
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        
        setupAutoLayout()
    }
    
    private func updateAppearance(_ isSelected: Bool) {
        addImageButton.image = isSelected ? UIImage(named: "MinusButton") : UIImage(systemName: "plus.app")
    }
    
    // MARK: - Actions
    
    @objc
    func addImageButtonTapped() {
        isAddImageButtonSelected.toggle()
        addImageButtonClicked?()
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
