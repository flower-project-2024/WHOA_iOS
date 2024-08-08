//
//  PurposeViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import Foundation
import Combine

final class PurposeViewModel {
    
    // MARK: - Properties
    
    struct Input {
        let purposePublisher: AnyPublisher<PurposeType, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher<PurposeType, Never>
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        let updateViewPublisher = input.purposePublisher
        return Output(updateViewPublisher: updateViewPublisher)
    }
}
