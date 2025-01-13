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
        static let todaysFlowerViewCell2Identifier = "TodaysFlowerViewCell2"
        static let customizeIntroCell2Identifier = "CustomizeIntroCell2"
    }
    
    // MARK: - Properties
    
    private var bannerTimer: Timer?
    
    private lazy var repeatedBannerItems: [Int] = {
        var array = [Int]()
        for i in 0..<30 {
            for item in [1, 2] {
                array.append(i * 2 + item)
            }
        }
        return array
    }()
    
    // MARK: - UI
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: HomeMainLayoutProvider.createCompositionalLayout())
        collectionView.register(
            SearchBarCell.self,
            forCellWithReuseIdentifier: Attributes.searchBarCellIdentifier
        )
        
        collectionView.register(
            TodaysFlowerViewCell2.self,
            forCellWithReuseIdentifier: Attributes.todaysFlowerViewCell2Identifier
        )
        
        collectionView.register(
            CustomizeIntroCell2.self,
            forCellWithReuseIdentifier: Attributes.customizeIntroCell2Identifier
        )
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
                
            case .banner:
                if itemIdentifier % 2 == 1 {
                    return collectionView.dequeueReusableCell(
                        withReuseIdentifier: Attributes.todaysFlowerViewCell2Identifier,
                        for: indexPath
                    ) as? TodaysFlowerViewCell2
                } else {
                    return collectionView.dequeueReusableCell(
                        withReuseIdentifier: Attributes.customizeIntroCell2Identifier,
                        for: indexPath
                    ) as? CustomizeIntroCell2
                }
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
        startBannerTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    deinit {
        stopBannerTimer()
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
        snapshot.appendSections([.searchBar, .banner])
        snapshot.appendItems([0], toSection: .searchBar)
        snapshot.appendItems(repeatedBannerItems, toSection: .banner)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        // banner 중간에서 시작
        DispatchQueue.main.async {
            let midIndex = self.repeatedBannerItems.count / 2
            let midPath = IndexPath(item: midIndex, section: HomeSection.banner.rawValue)
            self.collectionView.scrollToItem(at: midPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    private func startBannerTimer() {
        bannerTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.scrollToNextBanner()
        }
    }
    
    private func stopBannerTimer() {
        bannerTimer?.invalidate()
        bannerTimer = nil
    }
    
    private func scrollToNextBanner() {
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        let bannerIndexPaths = visibleIndexPaths.filter { $0.section == HomeSection.banner.rawValue }
        guard let currentIndexPath = bannerIndexPaths.first else { return }
        
        let nextItem = currentIndexPath.item + 1
        let itemCount = repeatedBannerItems.count
        
        if nextItem >= itemCount {
            let midIndex = itemCount / 2 - 1 // 자연스러운 UI를 위해 마지막 뷰와 같은 index 부여
            let midPath = IndexPath(item: midIndex, section: HomeSection.banner.rawValue)
            collectionView.scrollToItem(at: midPath, at: .centeredHorizontally, animated: false)
        } else {
            let nextPath = IndexPath(item: nextItem, section: HomeSection.banner.rawValue)
            collectionView.scrollToItem(at: nextPath, at: .centeredHorizontally, animated: true)
        }
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
