//
//  CustomStartViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 8/16/24.
//

import Foundation
import Combine

final class CustomStartViewModel: ViewModel {
    
    // MARK: - Properties
    
    struct Input {
        let textInput: AnyPublisher<String, Never>
        let startButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let requestTitle: AnyPublisher<String, Never>
        let showPurpose: AnyPublisher<Void, Never>
    }
    
    private let dataManager: BouquetDataManaging
    private let textInputSubject = CurrentValueSubject<String, Never>("")
    private let showPurposeSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        input.textInput
            .assign(to: \.value, on: textInputSubject)
            .store(in: &cancellables)
        
        input.startButtonTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.dataManager.setRequestTitle(self.textInputSubject.value)
                self.showPurposeSubject.send()
            }
            .store(in: &cancellables)
        
        return Output(
            requestTitle: textInputSubject.eraseToAnyPublisher(),
            showPurpose: showPurposeSubject.eraseToAnyPublisher()
        )
    }
}
