//
//  DataManager.swift
//  WHOA_iOS
//
//  Created by KSH on 8/25/24.
//

import Foundation

protocol BouquetDataManaging {
    func reset()
    
    // MARK: - Set
    func setPurpose(_ purpose: PurposeType)
    func setColorScheme(_ colorScheme: BouquetData.ColorScheme)
    func setFlowers(_ flowers: [BouquetData.Flower])
    func setAlternative(_ alternative: AlternativesType)
    func setAssign(_ assign: Assign)
    func setPrice(_ price: BouquetData.Price)
    func setRequirement(_ requirement: BouquetData.Requirement)
    
    // MARK: - Get
    func getPurpose() -> PurposeType
    func getColorScheme() -> BouquetData.ColorScheme
    func getFlowers() -> [BouquetData.Flower]
    func getAlternative() -> AlternativesType
    func getAssign() -> Assign
    func getPrice() -> BouquetData.Price
    func getRequirement() -> BouquetData.Requirement
}

class DataManager: BouquetDataManaging {
    static let shared = DataManager()
    
    private var bouquetData: BouquetData?
    
    private init() {}
    
    func reset() {
        bouquetData = BouquetData(
            purpose: .none,
            colorScheme: .init(numberOfColors: .none, pointColor: nil, colors: []),
            flowers: [],
            alternative: .none,
            assign: Assign(packagingAssignType: .none, text: ""),
            price: .init(min: 0, max: 150000),
            requirement: .init(text: "", images: [])
        )
    }
    
    // MARK: - Set
    
    func setPurpose(_ purpose: PurposeType) {
        if bouquetData == nil { reset() }
        bouquetData?.purpose = purpose
    }
    
    func setColorScheme(_ colorScheme: BouquetData.ColorScheme) {
        if bouquetData == nil { reset() }
        bouquetData?.colorScheme = colorScheme
    }
    
    func setFlowers(_ flowers: [BouquetData.Flower]) {
        if bouquetData == nil { reset() }
        bouquetData?.flowers = flowers
    }
    
    func setAlternative(_ alternative: AlternativesType) {
        if bouquetData == nil { reset() }
        bouquetData?.alternative = alternative
    }
    
    func setAssign(_ assign: Assign) {
        if bouquetData == nil { reset() }
        bouquetData?.assign = assign
    }
    
    func setPrice(_ price: BouquetData.Price) {
        if bouquetData == nil { reset() }
        bouquetData?.price = price
    }
    
    func setRequirement(_ requirement: BouquetData.Requirement) {
        if bouquetData == nil { reset() }
        bouquetData?.requirement = requirement
    }
    
    // MARK: - Get
    
    func getPurpose() -> PurposeType {
        return bouquetData?.purpose ?? .none
    }
    
    func getColorScheme() -> BouquetData.ColorScheme {
        return bouquetData?.colorScheme ?? BouquetData.ColorScheme(numberOfColors: .none, pointColor: nil, colors: [])
    }
    
    func getFlowers() -> [BouquetData.Flower] {
        return bouquetData?.flowers ?? []
    }
    
    func getAlternative() -> AlternativesType {
        return bouquetData?.alternative ?? .none
    }
    
    func getAssign() -> Assign {
        return bouquetData?.assign ?? Assign(packagingAssignType: .none, text: "")
    }
    
    func getPrice() -> BouquetData.Price {
        return bouquetData?.price ?? BouquetData.Price(min: 0, max: 150000)
    }
    
    func getRequirement() -> BouquetData.Requirement {
        return bouquetData?.requirement ?? BouquetData.Requirement(text: "", images: [])
    }
}
