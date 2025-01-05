//
//  ManagementView.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/25/24.
//

import UIKit

class ManagementView: UIView {
    
    // MARK: - Properties
    
    static var cellSize = CGSize(width: 215, height: 278)
    static let minimumLineSpacing: CGFloat = 12.0
    
    // MARK: - Views
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "관리법과 보관법을 알려드릴게요"
        label.font = .Pretendard(size: 20, family: .Bold)
        label.textColor = UIColor.customPrimary
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = ManagementView.minimumLineSpacing
        flowLayout.itemSize = ManagementView.cellSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .zero
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.gray02
        
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func addViews() {
        addSubview(titleLabel)
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(26)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(ManagementView.cellSize.height)
            make.bottom.equalToSuperview().inset(17)
        }
    }
}
