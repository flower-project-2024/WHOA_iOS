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
        let setupAssignText: AnyPublisher<String, Never>
        let nextButtonEnabled: AnyPublisher<Bool, Never>
        let showFlowerPriceView: AnyPublisher<Void, Never>
    }
    
    private let dataManager: BouquetDataManaging
    private let packagingAssignSubject: CurrentValueSubject<PackagingAssignType, Never>
    private let textInputSubject: CurrentValueSubject<String, Never>
    private let showFlowerPriceViewSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = BouquetDataManager.shared) {
        self.dataManager = dataManager
        let packagingAssign = dataManager.getPackagingAssign()
        self.packagingAssignSubject = .init(packagingAssign.assign)
        self.textInputSubject = .init(packagingAssign.text ?? "")
    }
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        let setupAssignTextPublisher = Just(textInputSubject.value)
        
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
        
        input.nextButtonTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                let assign = BouquetData.PackagingAssign(
                    assign: packagingAssignSubject.value,
                    text: textInputSubject.value
                )
                self.dataManager.setPackagingAssign(assign)
                self.showFlowerPriceViewSubject.send()
            }
            .store(in: &cancellables)
        
        return Output(
            setupPackagingAssign: packagingAssignSubject.eraseToAnyPublisher(),
            setupAssignText: setupAssignTextPublisher.eraseToAnyPublisher(),
            nextButtonEnabled: nextButtonEnabled.eraseToAnyPublisher(),
            showFlowerPriceView: showFlowerPriceViewSubject.eraseToAnyPublisher()
        )
    }
}
