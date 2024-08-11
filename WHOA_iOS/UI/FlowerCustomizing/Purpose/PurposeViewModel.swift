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
        let purposeChanged: AnyPublisher<PurposeType, Never>
    }
    
    struct Output {
        let purposeType: AnyPublisher<PurposeType, Never>
    }
    
    private let purposeSubject = CurrentValueSubject<PurposeType, Never>(.none)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        input.purposeChanged
            .subscribe(purposeSubject)
            .store(in: &cancellables)
        
        return Output(purposeType: purposeSubject.eraseToAnyPublisher())
    }
}
