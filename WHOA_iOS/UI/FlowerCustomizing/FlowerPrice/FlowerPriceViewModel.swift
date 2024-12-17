//
//  FlowerPriceViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 5/3/24.
//

import Foundation
import Combine

final class FlowerPriceViewModel: ViewModel {
    
    // MARK: - Properties
    
    struct Input {
        let minPriceChanged: AnyPublisher<Double, Never>
        let maxPriceChanged: AnyPublisher<Double, Never>
        let nextButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let initPriceRange: AnyPublisher<(Int, Int), Never>
        let updatePriceLabel: AnyPublisher<String, Never>
        let showPhotoSelectionView: AnyPublisher<Void, Never>
    }
    
    let dataManager: BouquetDataManaging
    private let minPriceSubject = CurrentValueSubject<Int, Never>(0)
    private let maxPriceSubject = CurrentValueSubject<Int, Never>(100000)
    private let showPhotoSelectionViewSubject = PassthroughSubject<Void, Never>()
    var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = BouquetDataManager.shared) {
        self.dataManager = dataManager
        let price = dataManager.getPrice()
        minPriceSubject.send(price.min)
        maxPriceSubject.send(price.max)
    }
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        let initPriceRange = Just((minPriceSubject.value, maxPriceSubject.value))
        
        input.minPriceChanged
            .map { minPrice in
                minPrice.roundedToThousands()
            }.assign(to: \.value, on: minPriceSubject)
            .store(in: &cancellables)
        
        input.maxPriceChanged
            .map { maxPrice in
                maxPrice.roundedToThousands()
            }.assign(to: \.value, on: maxPriceSubject)
            .store(in: &cancellables)
        
        let updatePriceLabel = Publishers.CombineLatest(minPriceSubject, maxPriceSubject)
            .map { minPrice, maxPrice in
                let formattedMinPrice = String(minPrice).formatNumberInThousands()
                let formattedMaxPrice = String(maxPrice).formatNumberInThousands()
                return "\(formattedMinPrice)원 ~ \(formattedMaxPrice)원"
            }
        
        input.nextButtonTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                let price = BouquetData.Price(
                    min: minPriceSubject.value,
                    max: maxPriceSubject.value
                )
                self.dataManager.setPrice(price)
                self.showPhotoSelectionViewSubject.send()
            }
            .store(in: &cancellables)
        
        return Output(
            initPriceRange: initPriceRange.eraseToAnyPublisher(),
            updatePriceLabel: updatePriceLabel.eraseToAnyPublisher(),
            showPhotoSelectionView: showPhotoSelectionViewSubject.eraseToAnyPublisher()
        )
    }
}
