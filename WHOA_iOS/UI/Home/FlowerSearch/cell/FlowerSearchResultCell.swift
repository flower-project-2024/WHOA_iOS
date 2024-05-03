//
//  FlowerSearchResultCell.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/18/24.
//

import UIKit

class FlowerSearchResultCell: UITableViewCell {
    // MARK: - Properties
    static let identifier: String = "FlowerSearchResultCell"
    
    // MARK: - Views
    private let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SearchIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func addViews(){
        addSubview(searchImageView)
        addSubview(resultLabel)
    }
    
    private func setupConstraints(){
        searchImageView.snp.makeConstraints { make in
            make.width.equalTo(21)
            make.height.equalTo(searchImageView.snp.width).multipliedBy(1)
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        resultLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchImageView.snp.trailing).offset(8)
            make.centerY.equalTo(searchImageView.snp.centerY)
        }
    }
}
