//
//  HomeMainLayoutProvider.swift
//  WHOA_iOS
//
//  Created by KSH on 12/13/24.
//

import UIKit

struct HomeMainLayoutProvider {
    
    static func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = HomeSection(rawValue: sectionIndex) else { return nil }
            return layout(for: section)
        }
    }
    
    private static func layout(for section: HomeSection) -> NSCollectionLayoutSection {
        switch section {
        case .searchBar:
            return createSingleItemSection(
                height: 54,
                insets: NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            )
        }
    }
    
    private static func createSingleItemSection(height: CGFloat, insets: NSDirectionalEdgeInsets) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(height)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(height)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = insets
        return section
    }
}
