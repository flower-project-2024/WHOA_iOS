//
//  BouquetDataManager.swift
//  WHOA_iOS
//
//  Created by KSH on 8/25/24.
//

import Foundation

protocol BouquetDataManaging {
    func reset()
    
    // MARK: - Set
    
    func setBouquet(_ bouquetData: BouquetData)
    func setRequestTitle(_ title: String)
    func setPurpose(_ purpose: PurposeType)
    func setColorScheme(_ colorScheme: BouquetData.ColorScheme)
    func setFlowers(_ flowers: [BouquetData.Flower])
    func setAlternative(_ alternative: AlternativesType)
    func setPackagingAssign(_ assign: BouquetData.PackagingAssign)
    func setPrice(_ price: BouquetData.Price)
    func setRequirement(_ requirement: BouquetData.Requirement)
    func setActionType(_ actionType: ActionType)
    
    // MARK: - Get
    
    func getBouquet() -> BouquetData
    func getRequestTitle() -> String
    func getPurpose() -> PurposeType
    func getColorScheme() -> BouquetData.ColorScheme
    func getFlowers() -> [BouquetData.Flower]
    func getAlternative() -> AlternativesType
    func getPackagingAssign() -> BouquetData.PackagingAssign
    func getPrice() -> BouquetData.Price
    func getRequirement() -> BouquetData.Requirement
    func getActionType() -> ActionType
}

class BouquetDataManager: BouquetDataManaging {
    
    static let shared = BouquetDataManager()
    
    private var actionType: ActionType = .create
    private var bouquetData: BouquetData = BouquetData(
        requestTitle: "",
        purpose: .none,
        colorScheme: .init(numberOfColors: .none, pointColor: nil, colors: []),
        flowers: [],
        alternative: .none,
        packagingAssign: .init(assign: .none, text: ""),
        price: .init(min: 0, max: 100000),
        requirement: .init(text: "", images: [])
    )
    
    private init() {}
    
    func reset() {
        bouquetData = BouquetData(
            requestTitle: "",
            purpose: .none,
            colorScheme: .init(numberOfColors: .none, pointColor: nil, colors: []),
            flowers: [],
            alternative: .none,
            packagingAssign: .init(assign: .none, text: ""),
            price: .init(min: 0, max: 100000),
            requirement: .init(text: "", images: [])
        )
    }
    
    // MARK: - Set
    
    func setBouquet(_ bouquetData: BouquetData) {
        self.bouquetData = bouquetData
    }
    
    func setRequestTitle(_ title: String) {
        bouquetData.requestTitle = title
    }
    
    func setPurpose(_ purpose: PurposeType) {
        bouquetData.purpose = purpose
    }
    
    func setColorScheme(_ colorScheme: BouquetData.ColorScheme) {
        bouquetData.colorScheme = colorScheme
    }
    
    func setFlowers(_ flowers: [BouquetData.Flower]) {
        bouquetData.flowers = flowers
    }
    
    func setAlternative(_ alternative: AlternativesType) {
        bouquetData.alternative = alternative
    }
    
    func setPackagingAssign(_ assign: BouquetData.PackagingAssign) {
        bouquetData.packagingAssign = assign
    }
    
    func setPrice(_ price: BouquetData.Price) {
        bouquetData.price = price
    }
    
    func setRequirement(_ requirement: BouquetData.Requirement) {
        bouquetData.requirement = requirement
    }
    
    func setActionType(_ actionType: ActionType) {
        self.actionType = actionType
    }
    
    // MARK: - Get
    
    func getBouquet() -> BouquetData {
        return bouquetData
    }
    
    func getRequestTitle() -> String {
        return bouquetData.requestTitle
    }
    
    func getPurpose() -> PurposeType {
        return bouquetData.purpose
    }
    
    func getColorScheme() -> BouquetData.ColorScheme {
        return bouquetData.colorScheme
    }
    
    func getFlowers() -> [BouquetData.Flower] {
        return bouquetData.flowers
    }
    
    func getAlternative() -> AlternativesType {
        return bouquetData.alternative
    }
    
    func getPackagingAssign() -> BouquetData.PackagingAssign {
        return bouquetData.packagingAssign
    }
    
    func getPrice() -> BouquetData.Price {
        return bouquetData.price
    }
    
    func getRequirement() -> BouquetData.Requirement {
        return bouquetData.requirement
    }
    
    func getActionType() -> ActionType {
        return actionType
    }
}
