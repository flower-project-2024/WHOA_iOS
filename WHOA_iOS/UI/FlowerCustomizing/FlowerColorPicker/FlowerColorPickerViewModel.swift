//
//  FlowerColorPickerViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import Foundation
import Combine

final class FlowerColorPickerViewModel: ViewModel {
    
    // MARK: - Properties
    
    struct Input {
        let backButtonTapped: AnyPublisher<Void, Never>
        let nextButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let dismissView: AnyPublisher<Void, Never>
        let showFlowerSelection: AnyPublisher<Void, Never>
    }
    
    private let dataManager: BouquetDataManaging
    private let dismissSubject = PassthroughSubject<Void, Never>()
    private let showFlowerSelectionSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = BouquetDataManager.shared) {
        self.dataManager = dataManager
    }
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        
        input.backButtonTapped
            .sink { [weak self] _ in
                self?.dismissSubject.send()
            }
            .store(in: &cancellables)
        
        input.nextButtonTapped
            .sink { [weak self] _ in
                // DataManager Data 전달 로직 추가 필요
                self?.showFlowerSelectionSubject.send()
            }
            .store(in: &cancellables)
        
        return Output(
            dismissView: dismissSubject.eraseToAnyPublisher(),
            showFlowerSelection: showFlowerSelectionSubject.eraseToAnyPublisher()
        )
    }
}
