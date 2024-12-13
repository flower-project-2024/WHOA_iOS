//
//  HomeMainView.swift
//  WHOA_iOS
//
//  Created by KSH on 12/12/24.
//

import UIKit
import SnapKit

final class HomeMainView: UIView {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let searchBarViewTopOffset = 24.0
        static let sideMargin = 20.0
        static let searchBarViewHeight = 54.0
    }
    
    /// Attributes
    private enum Attributes {
        static let searchBarCellIdentifier = "SearchBarCell"
    }
    
    // MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: HomeMainLayoutProvider.createCompositionalLayout())
        collectionView.register(SearchBarCell.self, forCellWithReuseIdentifier: Attributes.searchBarCellIdentifier)
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource = {
        return UICollectionViewDiffableDataSource<HomeSection, Int>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let section = HomeSection(rawValue: indexPath.section) else { return nil }
            switch section {
            case .searchBar:
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: Attributes.searchBarCellIdentifier,
                    for: indexPath
                ) as? SearchBarCell
            }
        }
    }()
    
    // MARK: - initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupAutoLayout()
        setupUI()
        initialSnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func addSubviews() {
        [
            collectionView
        ].forEach(addSubview(_:))
    }
    
    private func setupUI() {
        backgroundColor = .white
    }
    
    private func initialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, Int>()
        snapshot.appendSections([.searchBar])
        snapshot.appendItems([0], toSection: .searchBar)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - AutoLayout

extension HomeMainView {
    private func setupAutoLayout() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(Metric.searchBarViewTopOffset)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
