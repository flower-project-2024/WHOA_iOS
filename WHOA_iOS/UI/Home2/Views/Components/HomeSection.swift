//
//  HomeSection.swift
//  WHOA_iOS
//
//  Created by KSH on 12/13/24.
//

import UIKit

enum HomeSection: Int, CaseIterable {
    case searchBar
    case banner
    case popularRanking
    case cheapRanking
}

enum HomeSectionItem: Hashable {
    case searchBar
    case bannerFlower(id: UUID, flower: TodaysFlowerModel)
    case bannerCustomize(id: UUID)
    case rankingItem(id: UUID, cheapFlower: CheapFlowerModel)
    case popularRankingItem(id: UUID, popularFlower: popularityData)
}
