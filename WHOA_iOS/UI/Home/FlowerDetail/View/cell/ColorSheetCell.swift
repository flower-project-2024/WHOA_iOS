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
                colorDescriptionLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
                backgroundColor = UIColor(red: 213/255, green: 249/255, blue: 239/255, alpha: 1)
                layer.borderColor = UIColor(named: "Secondary03")?.cgColor
                layer.borderWidth = 1
            }
            else {
                colorDescriptionLabel.font = UIFont(name: "Pretendard-Regular", size: 16)
                backgroundColor = UIColor(named: "Gray02")
                layer.borderColor = .none
                layer.borderWidth = .zero
            }
        }
    }
    
    // MARK: - Views
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    lazy var colorChipView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.layer.cornerRadius = colorChipWidth / 2
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var colorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "사랑의 고백"
        label.textColor = UIColor(named: "Primary")
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    
    // MARK: - Initialization
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        layer.cornerRadius = 8
//        backgroundColor = UIColor(named: "Gray02")
//        layer.masksToBounds = true
//        
//        addViews()
//        setupConstraints()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8
        contentView.layer.masksToBounds = false
        backgroundColor = UIColor(named: "Gray02")
        
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0))
//    }
    
    // MARK: - Helpers
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        if selected {
//            contentView.layer.borderWidth = 1
//            contentView.backgroundColor = UIColor(hexCode: "D5F9EF")
//            contentView.layer.borderColor = UIColor.secondary02.cgColor
//        }
//        else {
//            contentView.layer.borderWidth = 0
//            contentView.layer.borderColor = .none
//            contentView.backgroundColor = .gray02
//        }
//    }
    
    func setupData(colorCode: String, colorDescription: String) {
        colorChipView.backgroundColor = UIColor.init(hexCode: colorCode)
        colorDescriptionLabel.text = colorDescription
        print("cell: \(isUserInteractionEnabled)")
        print("contentview: \(contentView.isUserInteractionEnabled)")
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
            //make.top.bottom.equalToSuperview().inset(17)
            make.centerY.equalToSuperview()
        }
        
        colorChipView.snp.makeConstraints { make in
            make.width.height.equalTo(colorChipWidth)
        }
    }
}
