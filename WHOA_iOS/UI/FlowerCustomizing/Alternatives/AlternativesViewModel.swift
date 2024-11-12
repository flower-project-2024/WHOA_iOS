//
//  AlternativesViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 4/27/24.
//

import Foundation
import Combine

final class AlternativesViewModel: ViewModel {
    
    // MARK: - Properties
    
    struct Input {
        let alternativeSelected: AnyPublisher<AlternativesType, Never>
        let nextButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let setupAlternative: AnyPublisher<AlternativesType, Never>
        let showPackagingSelectionView: AnyPublisher<Void, Never>
    }
    
    let dataManager: BouquetDataManaging
    private let alternativeSubject: CurrentValueSubject<AlternativesType, Never>
    private let showPackagingSelectionViewSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = BouquetDataManager.shared) {
        self.dataManager = dataManager
        self.alternativeSubject = .init(dataManager.getAlternative())
    }
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        input.alternativeSelected
            .assign(to: \.value, on: alternativeSubject)
            .store(in: &cancellables)
        
        input.nextButtonTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.dataManager.setAlternative(alternativeSubject.value)
                self.showPackagingSelectionViewSubject.send()
            }
            .store(in: &cancellables)
        
        return Output(
            setupAlternative: alternativeSubject.eraseToAnyPublisher(),
            showPackagingSelectionView: showPackagingSelectionViewSubject.eraseToAnyPublisher()
        )
    }
}
