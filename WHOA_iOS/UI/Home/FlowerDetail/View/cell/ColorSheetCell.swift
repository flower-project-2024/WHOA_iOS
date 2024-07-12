//
//  ColorSheetCell.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/31/24.
//

import UIKit

class ColorSheetCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let colorChipWidth: CGFloat = 20
    static let identifier = "ColorSheetCell"
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                colorDescriptionLabel.font = .Pretendard(size: 16, family: .SemiBold)
                backgroundColor = UIColor(red: 213/255, green: 249/255, blue: 239/255, alpha: 1)
                layer.borderColor = UIColor.secondary03.cgColor
                layer.borderWidth = 1
            }
            else {
                colorDescriptionLabel.font = .Pretendard(size: 16, family: .Regular)
                backgroundColor = UIColor.gray02
                layer.borderColor = .none
                layer.borderWidth = .zero
            }
        }
    }
    
    // MARK: - Views
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    private lazy var colorChipView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.layer.cornerRadius = colorChipWidth / 2
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var colorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.primary
        label.font = .Pretendard(size: 16, family: .Regular)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8
        contentView.layer.masksToBounds = false
        backgroundColor = UIColor.gray02
        
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helpers
        
    func setupData(colorCode: String, colorDescription: String) {
        colorChipView.backgroundColor = UIColor(hex: colorCode)
        if colorCode == "#FDFFF8" {
            colorChipView.layer.borderColor = UIColor(hex: "#CACDC2", alpha: 1).cgColor
            colorChipView.layer.borderWidth = 0.5
        }
        colorDescriptionLabel.text = colorDescription
    }
    
    private func addViews(){
        contentView.addSubview(stackView)
        
        [colorChipView, colorDescriptionLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        colorChipView.snp.makeConstraints { make in
            make.width.height.equalTo(colorChipWidth)
        }
    }
}
