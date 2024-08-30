//
//  PurposeViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import Foundation
import Combine

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

final class PurposeViewModel: ViewModel {
    
    // MARK: - Properties
    
    struct Input {
        let purposeSelected: AnyPublisher<PurposeType, Never>
        let nextButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let initialPurpose: AnyPublisher<PurposeType, Never>
        let purposeType: AnyPublisher<PurposeType, Never>
        let showColorPicker: AnyPublisher<Void, Never>
    }
    
    private let dataManager: BouquetDataManaging
    private let purposeSubject: CurrentValueSubject<PurposeType, Never>
    private let showColorPickerSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
        
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = DataManager.shared) {
        self.dataManager = dataManager
        self.purposeSubject = CurrentValueSubject<PurposeType, Never>(dataManager.getPurpose())
    }
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        let initialPurposePublisher = Just(purposeSubject.value)
        
        input.purposeSelected
            .sink { [weak self] selectedPurpose in
                guard let self = self else { return }
                
                if self.purposeSubject.value == selectedPurpose {
                    self.purposeSubject.send(.none)
                } else {
                    self.purposeSubject.send(selectedPurpose)
                }
            }
            .store(in: &cancellables)
        
        input.nextButtonTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.dataManager.setPurpose(self.purposeSubject.value)
                self.showColorPickerSubject.send()
            }
            .store(in: &cancellables)
        
        return Output(
            initialPurpose: initialPurposePublisher.eraseToAnyPublisher(),
            purposeType: purposeSubject.eraseToAnyPublisher(),
            showColorPicker: showColorPickerSubject.eraseToAnyPublisher()
        )
    }
}
