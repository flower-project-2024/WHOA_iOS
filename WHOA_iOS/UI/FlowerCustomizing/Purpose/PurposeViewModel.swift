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
        let PurposePublisher: AnyPublisher<PurposeType, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher<Void, Never>
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Fuctions
    

}
