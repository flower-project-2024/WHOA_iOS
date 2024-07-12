//
//  FlowerSelectionTableViewCell.swift
//  WHOA_iOS
//
//  Created by KSH on 2/28/24.
//

import UIKit

protocol FlowerSelectionTableViewCellDelegate: AnyObject {
    func didTapAddImageButton(in cell: FlowerSelectionTableViewCell)
}

class FlowerSelectionTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: FlowerSelectionTableViewCellDelegate?
    
    var isAddImageButtonSelected: Bool = false {
        didSet {
            updateAppearance(isAddImageButtonSelected)
        }
    }
    
    var addImageButtonClicked: (() -> Void)?
    
    // MARK: - UI
    
    let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TempImage")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let flowerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "튤립"
        label.textColor = .primary
        label.font = .Pretendard(size: 16, family: .SemiBold)
        return label
    }()
    
    lazy var addImageButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.app")
        imageView.tintColor = .gray9
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addImageButtonTapped))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private let flowerLanguageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray8
        label.font = .Pretendard(family: .Medium)
        label.numberOfLines = 3
        return label
    }()
    
    private let flowerDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
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
        backgroundColor = .white
        selectionStyle = .none
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray3.cgColor
        
        contentView.addSubview(flowerDescriptionView)
        flowerDescriptionView.addSubview(flowerNameLabel)
        flowerDescriptionView.addSubview(addImageButton)
        flowerDescriptionView.addSubview(flowerLanguageLabel)
        
        contentView.addSubview(fullHStackView)
        
        setupAutoLayout()
        updateAppearance(isAddImageButtonSelected)
    }
    
    private func updateAppearance(_ isSelected: Bool) {
        addImageButton.image = isSelected ? UIImage(named: "MinusButton") : UIImage(systemName: "plus.app")
    }
    
    func configUI(model: FlowerKeywordModel) {
        flowerNameLabel.text = model.flowerName
        flowerLanguageLabel.text = model.flowerLanguage
        
        if let image = model.flowerImage, let imageURL = URL(string: image) {
            flowerImageView.load(url: imageURL)
        } else {
            flowerImageView.image = UIImage(named: "TempImage")
        }
    }
    
    // MARK: - Actions
    
    @objc
    func addImageButtonTapped() {
        delegate?.didTapAddImageButton(in: self)
    }
}

extension FlowerSelectionTableViewCell {
    private func setupAutoLayout() {
        flowerImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(148)
        }
        
        flowerNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(60)
        }
        
        addImageButton.snp.makeConstraints {
            $0.centerY.equalTo(flowerNameLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(15)
            $0.size.equalTo(18)
        }
        
        flowerLanguageLabel.snp.makeConstraints {
            $0.top.equalTo(flowerNameLabel.snp.bottom).offset(13)
            $0.leading.equalTo(flowerNameLabel.snp.leading)
            $0.trailing.equalToSuperview().offset(-5)
        }
        
        fullHStackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}