//
//  FlowerPriceViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 5/3/24.
//

import Foundation
import Combine

final class FlowerPriceViewModel {
    
    // MARK: - Properties
    
    let dataManager: BouquetDataManaging
    @Published var flowerPriceModel = FlowerPriceModel(minPrice: 0, maxPrice: 150000)
    var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = BouquetDataManager.shared) {
        self.dataManager = dataManager
        let price = dataManager.getPrice()
        setPrice(min: Double(price.min), max: Double(price.max))
    }
    
    // MARK: - Functions
    
    func setPrice(min: Double, max: Double) {
        flowerPriceModel = FlowerPriceModel(minPrice: formatNumberToThousands(min), maxPrice: formatNumberToThousands(max))
    }
    
    func getPriceString() -> String {
        return "\(flowerPriceModel.minPrice.decimalFormattedString()) ~ \(flowerPriceModel.maxPrice.decimalFormattedString())원"
    }
    
    private func formatNumberToThousands(_ number: Double) -> Int {
        return Int(round(number / 1000.0) * 1000)
    }
}
