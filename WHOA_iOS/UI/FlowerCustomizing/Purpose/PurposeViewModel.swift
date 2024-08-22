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
        let purposeType: AnyPublisher<PurposeType, Never>
        let showColorPicker: AnyPublisher<PurposeType, Never>
    }
    
    private let purposeSubject = CurrentValueSubject<PurposeType, Never>(.none)
    private let showColorPickerSubject = PassthroughSubject<PurposeType, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        input.purposeSelected
            .assign(to: \.value, on: purposeSubject)
            .store(in: &cancellables)
        
        input.nextButtonTapped
            .sink { [weak self] in
                guard let self = self else { return }
                self.showColorPickerSubject.send(self.purposeSubject.value)
            }
            .store(in: &cancellables)
        
        return Output(
            purposeType: purposeSubject.eraseToAnyPublisher(),
            showColorPicker: showColorPickerSubject.eraseToAnyPublisher()
        )
    }
}
