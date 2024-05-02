//
//  FlowerPriceViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 5/3/24.
//

import Foundation
import Combine

class FlowerPriceViewModel {
    
    // MARK: - Properties
    
    @Published var flowerPriceModel = FlowerPriceModel(minPrice: 0, maxPrice: 150000)
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Functions
    
    func setPrice(min: Double, max: Double) {
        flowerPriceModel = FlowerPriceModel(minPrice: formatNumberToThousands(min), maxPrice: formatNumberToThousands(max))
    }
    
    private func formatNumberToThousands(_ number: Double) -> Int {
        return Int(round(number / 1000.0) * 1000)
    }
}