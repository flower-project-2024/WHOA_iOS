//
//  FlowerListCell.swift
//  WHOA_iOS
//
//  Created by KSH on 2/28/24.
//

import UIKit

final class FlowerListCell: UITableViewCell {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let cornerRadius = 10.0
        static let borderWidth = 1.0
        static let flowerImageViewWidth = 148.0
        static let flowerNameLabelLeadingOffset = 20.0
        static let addImageButtonSize = 18.0
        static let addImageButtonTrailingOffset = -13.0
        static let trailingMargin = -5.0
        static let verticalSpacing = 13.0
    }
    
    /// Attributes
    private enum Attributes {
        static let minusImage = "MinusButton"
        static let plusImage = "plus.app"
    }
    
    // MARK: - UI
    
    let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let flowerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customPrimary
        label.font = .Pretendard(size: 16, family: .SemiBold)
        return label
    }()
    
    lazy var addImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Attributes.plusImage)
        imageView.tintColor = .gray09
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let flowerLanguageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray08
        label.font = .Pretendard(family: .Medium)
        label.numberOfLines = 3
        return label
    }()
    
    private let flowerDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray02
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
    
    // MARK: - Initialize
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: .zero, left: .zero, bottom: 12, right: .zero))
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        backgroundColor = .white
        selectionStyle = .none
        contentView.layer.cornerRadius = Metric.cornerRadius
        contentView.layer.borderWidth = Metric.borderWidth
        contentView.layer.borderColor = UIColor.gray03.cgColor
        contentView.layer.masksToBounds = true

        contentView.addSubview(flowerDescriptionView)
        flowerDescriptionView.addSubview(flowerNameLabel)
        flowerDescriptionView.addSubview(addImageView)
        flowerDescriptionView.addSubview(flowerLanguageLabel)

        contentView.addSubview(fullHStackView)

        setupAutoLayout()
    }
    
    func configUI(model: FlowerKeywordModel, isSelected: Bool) {
        flowerNameLabel.text = model.flowerName
        flowerLanguageLabel.text = model.flowerLanguage
        updateAddImageView(isSelected)
        
        if let image = model.flowerImage {
            ImageProvider.shared.setImage(into: flowerImageView, from: image)
        } else {
            flowerImageView.image = .defaultFlower
        }
    }
    
    func updateAddImageView(_ isSelected: Bool) {
        addImageView.image = isSelected ? UIImage(named: Attributes.minusImage) : UIImage(systemName: Attributes.plusImage)
    }
}

extension FlowerListCell {
    private func setupAutoLayout() {
        flowerImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(Metric.flowerImageViewWidth)
        }
        
        flowerNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Metric.verticalSpacing)
            $0.leading.equalToSuperview().offset(Metric.flowerNameLabelLeadingOffset)
            $0.trailing.equalTo(addImageView.snp.leading).offset(Metric.trailingMargin)
        }
        
        addImageView.snp.makeConstraints {
            $0.centerY.equalTo(flowerNameLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(Metric.addImageButtonTrailingOffset)
            $0.size.equalTo(Metric.addImageButtonSize)
        }
        
        flowerLanguageLabel.snp.makeConstraints {
            $0.top.equalTo(flowerNameLabel.snp.bottom).offset(Metric.verticalSpacing)
            $0.leading.equalTo(flowerNameLabel.snp.leading)
            $0.trailing.equalToSuperview().offset(Metric.trailingMargin)
        }
        
        fullHStackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
