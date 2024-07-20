//
//  ColorSheetViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/31/24.
//

import UIKit
import SnapKit

class ColorSheetViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: FlowerDetailViewModel
    
    var selectedColorIndex: Int? {
        didSet {
            decorateButton.configuration?.background.backgroundColor = UIColor.primary
            decorateButton.configuration?.baseForegroundColor = .white
            decorateButton.isEnabled = true
        }
    }
    
    var colorSelected: Bool = false
    
    // MARK: - Views
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .zero
        collectionView.clipsToBounds = true
        collectionView.register(ColorSheetCell.self, forCellWithReuseIdentifier: ColorSheetCell.identifier)
        collectionView.register(ColorSheetHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ColorSheetHeaderCell.identifier)
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private let bottomFixedView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowOpacity = 0.08
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()
    
    private let decorateButton: DecorateButton = {
        let button = DecorateButton()
        // 초기에 비활성화된 상태
        button.configuration?.background.backgroundColor = UIColor.gray03
        button.configuration?.baseForegroundColor = UIColor.gray05
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Initialization
    
    init(viewModel: FlowerDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addViews()
        setupConstraints()
    }
    
    // MARK: - Helpers
    
    private func addViews() {
        view.addSubview(collectionView)
        view.addSubview(bottomFixedView)
        
        bottomFixedView.addSubview(decorateButton)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(24)
            make.bottom.equalTo(bottomFixedView.snp.top)
        }
        
        decorateButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
        }
        
        bottomFixedView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - Extension

extension ColorSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getFlowerExpressionsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorSheetCell.identifier, for: indexPath) as? ColorSheetCell else { return UICollectionViewCell() }
        let data = viewModel.getFlowerExpressionAt(index: indexPath.item)
        cell.setupData(colorCode: data.flowerColor!, colorDescription: data.flowerLanguage!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColorIndex = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 헤더 커스텀
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ColorSheetHeaderCell.identifier, for: indexPath) as? ColorSheetHeaderCell else {
                return UICollectionViewCell()
            }
            return header
        }
        // 헤더 가져오는 데 에러
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: (collectionView.frame.width - 40), height: 76)
    }
}

extension ColorSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: (collectionView.frame.width - 40), height: 56)
    }
}
