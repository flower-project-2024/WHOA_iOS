//
//  PackagingSelectionViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 3/9/24.
//

import Foundation
import Combine

final class PackagingSelectionViewModel: ViewModel {
    
    // MARK: - Properties
    
    struct Input {
        let packagingAssignSelected: AnyPublisher<PackagingAssignType, Never>
        let textInput: AnyPublisher<String, Never>
        let nextButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let setupPackagingAssign: AnyPublisher<PackagingAssignType, Never>
        let nextButtonEnabled: AnyPublisher<Bool, Never>
        let showFlowerPriceView: AnyPublisher<Void, Never>
    }
    
    private let dataManager: BouquetDataManaging
    private let packagingAssignSubject: CurrentValueSubject<PackagingAssignType, Never>
    private let textInputSubject = CurrentValueSubject<String, Never>("")
    private let showFlowerPriceViewSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = BouquetDataManager.shared) {
        self.dataManager = dataManager
        let packagingAssign = dataManager.getPackagingAssign()
        self.packagingAssignSubject = .init(packagingAssign.assign)
    }
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        input.packagingAssignSelected
            .assign(to: \.value, on: packagingAssignSubject)
            .store(in: &cancellables)
        
        input.textInput
            .assign(to: \.value, on: textInputSubject)
            .store(in: &cancellables)
        
        let nextButtonEnabled = packagingAssignSubject
            .combineLatest(textInputSubject)
            .map { assignType, textInput in
                assignType == .managerAssign || (assignType == .myselfAssign && !textInput.isEmpty)
            }
            .eraseToAnyPublisher()
        
        return Output(
            setupPackagingAssign: packagingAssignSubject.eraseToAnyPublisher(),
            nextButtonEnabled: nextButtonEnabled.eraseToAnyPublisher(),
            showFlowerPriceView: showFlowerPriceViewSubject.eraseToAnyPublisher()
        )
    }
}
