//
//  PhotoSelectionViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 3/14/24.
//

import Foundation
import Combine

final class PhotoSelectionViewModel: ViewModel {
    
    // MARK: - Properties
    
    struct Input {
        let textInput: AnyPublisher<String, Never>
        let addImageButtonTapped: AnyPublisher<Void, Never>
        let minusButtonTapped: AnyPublisher<Int, Never>
        let nextButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let updatePhotosData: AnyPublisher<[Data], Never>
        let showCustomizingSummaryView: AnyPublisher<Void, Never>
    }
    
    private let dataManager: BouquetDataManaging
    private let photoAuthService: PhotoAuthService
    private let requirementPhotos = CurrentValueSubject<[Data], Never>([])
    private let textInputSubject = CurrentValueSubject<String, Never>("")
    private let showCustomizingSummaryViewSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    
    init(
        dataManager: BouquetDataManaging = BouquetDataManager.shared,
        authService: PhotoAuthService = MyPhotoAuthService()
    ) {
        self.photoAuthService = authService
        self.dataManager = dataManager
    }
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        input.textInput
            .assign(to: \.value, on: textInputSubject)
            .store(in: &cancellables)
        
        input.minusButtonTapped
            .sink { [weak self] index in
                self?.removePhoto(at: index)
            }
            .store(in: &cancellables)
        
        return Output(
            updatePhotosData: requirementPhotos.eraseToAnyPublisher(),
            showCustomizingSummaryView: showCustomizingSummaryViewSubject.eraseToAnyPublisher()
        )
    }
    
    private func removePhoto(at index: Int) {
        var currentPhotos = requirementPhotos.value
        
        guard index >= 0 && index < currentPhotos.count else { return }
        currentPhotos.remove(at: index)
        requirementPhotos.send(currentPhotos)
    }
}
