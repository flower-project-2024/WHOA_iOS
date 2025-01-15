//
//  HomeMainView.swift
//  WHOA_iOS
//
//  Created by KSH on 12/12/24.
//

import UIKit
import Combine
import SnapKit

final class HomeMainView: UIView {
    
    // MARK: - Enums
    
    /// Attributes
    private enum Attributes {
        static let searchBarCellIdentifier = "SearchBarCell"
        static let todaysFlowerViewCell2Identifier = "TodaysFlowerViewCell2"
        static let customizeIntroCell2Identifier = "CustomizeIntroCell2"
        static let rankingCellHeaderIdentifier = "RankingCellHeader"
        static let rankingCellIdentifier = "RankingCell"
    }
    
    // MARK: - Properties
    
    private let searchBarTappedSubject = PassthroughSubject<Void, Never>()
    
    var searchBarTappedPublisher: AnyPublisher<Void, Never> {
        searchBarTappedSubject.eraseToAnyPublisher()
    }

    private var todayFlowerModel: TodaysFlowerModel?
    private var bannerTimer: Timer?
    
    private lazy var repeatedBannerItems: [Int] = {
        var array = [Int]()
        for i in 0..<30 {
            for item in [101, 102] {
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
        
        collectionView.register(
            RankingCellHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: Attributes.rankingCellHeaderIdentifier
        )
        
        collectionView.register(
            RankingCell.self,
            forCellWithReuseIdentifier: Attributes.rankingCellIdentifier
        )
        return collectionView
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<HomeSection, Int> = {
        let dataSource = UICollectionViewDiffableDataSource<HomeSection, Int>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let section = HomeSection(rawValue: indexPath.section) else { return nil }
            
            switch section {
            case .searchBar:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: Attributes.searchBarCellIdentifier,
                    for: indexPath
                ) as? SearchBarCell else { return SearchBarCell() }
                
                cell.searchBarTapPublisher
                    .sink { [weak self] _ in
                        guard let self = self else { return }
                        self.searchBarTappedSubject.send()
                    }
                    .store(in: &cell.cancellables)
                
                return cell
                
            case .banner:
                if itemIdentifier % 2 == 1 {
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: Attributes.todaysFlowerViewCell2Identifier,
                        for: indexPath
                    ) as? TodaysFlowerViewCell2 else {
                        return nil
                    }
                    
                    if let data = self?.todayFlowerModel {
                        cell.configure(with: data)
                    }
                    
                    return cell
                } else {
                    return collectionView.dequeueReusableCell(
                        withReuseIdentifier: Attributes.customizeIntroCell2Identifier,
                        for: indexPath
                    ) as? CustomizeIntroCell2
                }
                
            case .cheapRanking, .popularRanking:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: Attributes.rankingCellIdentifier,
                    for: indexPath
                ) as? RankingCell else {
                    return nil
                }
                
                if section == .cheapRanking {
                    cell.configure(for: section, price: "2,100", colors: nil)
                } else if section == .popularRanking {
                    cell.configure(for: section, price: nil, colors: ["#FF5733"])
                }
                
                return cell
            }
        }
        
        // 헤더 설정
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            guard let section = HomeSection(rawValue: indexPath.section) else { return nil }
            
            switch section {
            case .cheapRanking, .popularRanking:
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: Attributes.rankingCellHeaderIdentifier,
                    for: indexPath
                ) as? RankingCellHeader
                
                header?.configure(for: section)
                return header
            default:
                return nil
            }
        }
        
        return dataSource
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
        snapshot.appendSections([.searchBar, .banner, .cheapRanking, .popularRanking])
        snapshot.appendItems([0], toSection: .searchBar)
        snapshot.appendItems(repeatedBannerItems, toSection: .banner)
        snapshot.appendItems([1, 2, 3], toSection: .cheapRanking)
        snapshot.appendItems([4, 5, 6], toSection: .popularRanking)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        // banner 중간에서 시작
        DispatchQueue.main.async {
            let midIndex = self.repeatedBannerItems.count / 2 + 1
            let midPath = IndexPath(item: midIndex, section: HomeSection.banner.rawValue)
            self.collectionView.scrollToItem(at: midPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    func updateTodaysFlower(with data: TodaysFlowerModel) {
        self.todayFlowerModel = data
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([101])
        dataSource.apply(snapshot, animatingDifferences: true)
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
            let midIndex = itemCount / 2 + 1
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
            $0.edges.equalToSuperview()
        }
    }
}
