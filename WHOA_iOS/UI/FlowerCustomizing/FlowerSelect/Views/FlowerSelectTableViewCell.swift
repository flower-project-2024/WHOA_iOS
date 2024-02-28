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
        imageView.image = UIImage(named: "IntentImage")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let flowerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "튤립"
        return label
    }()
    
    private let addImageButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.app")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var flowerNameHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            flowerNameLabel,
            addImageButton
        ].forEach { stackView.addArrangedSubview($0) }
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.backgroundColor = .green
        return stackView
    }()

    
    private let hashTag: UILabel = {
        let label = UILabel()
        label.text = "믿는 사랑"
        return label
    }()
    
    private let hashTag2: UILabel = {
        let label = UILabel()
        label.text = "추억"
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
        stackView.spacing = 9
        stackView.backgroundColor = .yellow
        return stackView
    }()
    
    private lazy var flowerDescriptionVStackView: UIStackView = {
        let stackView = UIStackView()
        [
            flowerNameHStackView,
            hashTagHStackView
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .blue
        return stackView
    }()
    
    private lazy var fullHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            flowerImageView,
            flowerDescriptionVStackView
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .red
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
    
    // MARK: - Functions
    private func setupUI() {
        addSubview(flowerDescriptionVStackView)
        addSubview(fullHStackView)
        
        setupAutoLayout()
    }
}

extension FlowerSelectTableViewCell {
    private func setupAutoLayout() {
        
        flowerImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(60)
        }
        
        addImageButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        flowerNameHStackView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.equalTo(flowerImageView.snp.trailing)
        }
        
        hashTagHStackView.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(flowerImageView.snp.trailing)
        }
        
        flowerDescriptionVStackView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(flowerImageView.snp.trailing)
        }
        
        fullHStackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
