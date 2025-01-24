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
    
    private var bannerTimer: Timer?
    
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
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeSectionItem> = {
        let dataSource = UICollectionViewDiffableDataSource<HomeSection, HomeSectionItem>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, item in
            guard let section = HomeSection(rawValue: indexPath.section) else { return nil }
            
            switch item {
            case .searchBar:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: Attributes.searchBarCellIdentifier,
                    for: indexPath
                ) as? SearchBarCell else {
                    return nil
                }
                
                cell.searchBarTapPublisher
                    .sink { [weak self] _ in
                        self?.searchBarTappedSubject.send()
                    }
                    .store(in: &cell.cancellables)
                return cell
                
            case .bannerFlower(_, let todayFlowerModel):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: Attributes.todaysFlowerViewCell2Identifier,
                    for: indexPath
                ) as? TodaysFlowerViewCell2 else {
                    return nil
                }
                cell.configure(with: todayFlowerModel)
                return cell
                
            case .bannerCustomize(_):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: Attributes.customizeIntroCell2Identifier,
                    for: indexPath
                ) as? CustomizeIntroCell2 else {
                    return nil
                }
                return cell
                
            case .rankingItem(_, let cheapFlowerModel):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: Attributes.rankingCellIdentifier,
                    for: indexPath
                ) as? RankingCell else {
                    return nil
                }
                let rank = indexPath.row + 1
                
                if section == .cheapRanking {
                    cell.configureCheapRanking(rank: rank, model: cheapFlowerModel)
                } else if section == .popularRanking {
                    cell.configurePopularRanking(rank: rank)
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
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeSectionItem>()
        snapshot.appendSections([.searchBar, .banner, .cheapRanking, .popularRanking])
        snapshot.appendItems([.searchBar], toSection: .searchBar)
        
        let dummyFlowerData = TodaysFlowerModel(
            flowerId: 999,
            flowerName: "유스가스",
            flowerOneLineDescription: "활기차게 전하는 노란 행복",
            flowerImage: "",
            flowerExpressions: []
        )
        let repeatedBannerItems = makeRepeatedBannerItems(with: dummyFlowerData)
        snapshot.appendItems(repeatedBannerItems, toSection: .banner)
        
        let dummyCheapFlowerModels = [
            HomeSectionItem.rankingItem(
                id: UUID(),
                cheapFlower: CheapFlowerModel(
                    flowerId: nil,
                    flowerRankingName: "장미",
                    flowerRankingLanguage: "사랑",
                    flowerRankingPrice: "1155",
                    flowerRankingDate: "2025-01-22",
                    flowerRankingImg: nil
                )),
            HomeSectionItem.rankingItem(
                id: UUID(),
                cheapFlower: CheapFlowerModel(
                    flowerId: nil,
                    flowerRankingName: "장미",
                    flowerRankingLanguage: "사랑",
                    flowerRankingPrice: "1155",
                    flowerRankingDate: "2025-01-22",
                    flowerRankingImg: nil
                )),
            HomeSectionItem.rankingItem(
                id: UUID(),
                cheapFlower: CheapFlowerModel(
                    flowerId: nil,
                    flowerRankingName: "장미",
                    flowerRankingLanguage: "사랑",
                    flowerRankingPrice: "1155",
                    flowerRankingDate: "2025-01-22",
                    flowerRankingImg: nil
                )),
        ]
        snapshot.appendItems(dummyCheapFlowerModels, toSection: .cheapRanking)
        
        snapshot.appendItems(dummyCheapFlowerModels, toSection: .popularRanking)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        // banner 중간에서 시작
        DispatchQueue.main.async {
            let midIndex = repeatedBannerItems.count / 2 + 1
            let midPath = IndexPath(item: midIndex, section: HomeSection.banner.rawValue)
            self.collectionView.scrollToItem(at: midPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    private func makeRepeatedBannerItems(
        with flowerData: TodaysFlowerModel,
        repeatCount: Int = 30
    ) -> [HomeSectionItem] {
        var items = [HomeSectionItem]()
        for _ in 0..<repeatCount {
            items.append(.bannerFlower(id: UUID(), flower: flowerData))
            items.append(.bannerCustomize(id: UUID()))
        }
        return items
    }
    
    func updateTodaysFlower(with data: TodaysFlowerModel) {
        var snapshot = dataSource.snapshot()
        
        let oldBannerItems = snapshot.itemIdentifiers(inSection: .banner)
        snapshot.deleteItems(oldBannerItems)
        
        let newBannerItems = makeRepeatedBannerItems(with: data, repeatCount: 30)
        snapshot.appendItems(newBannerItems, toSection: .banner)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func updateCheapFlowerRankings(_ newData: [CheapFlowerModel]) {
        var snapshot = dataSource.snapshot()
        let oldRankingItems = snapshot.itemIdentifiers(inSection: .cheapRanking)
        snapshot.deleteItems(oldRankingItems)
        
        let newRankingItems = newData.prefix(3).map { model in
            HomeSectionItem.rankingItem(
                id: UUID(),
                cheapFlower: model
            )
        }
        
        snapshot.appendItems(newRankingItems, toSection: .cheapRanking)
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
        
        var snapshot = dataSource.snapshot()
        let itemCount = snapshot.itemIdentifiers(inSection: .banner).count
        
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
