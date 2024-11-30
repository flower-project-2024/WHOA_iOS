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
        let photosSelected: AnyPublisher<[Data], Never>
        let nextButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let updatePhotosData: AnyPublisher<[Data], Never>
        let showPhotoView: AnyPublisher<Int, Never>
        let showCustomizingSummaryView: AnyPublisher<Void, Never>
    }
    
    private let dataManager: BouquetDataManaging
    private let photoAuthService: PhotoAuthService
    private let textInputSubject = CurrentValueSubject<String, Never>("")
    private let requirementPhotos = CurrentValueSubject<[Data], Never>([])
    private let showPhotoViewSubject = PassthroughSubject<Int, Never>()
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
        
        input.addImageButtonTapped
            .sink { [weak self] _ in
                self?.requestPhotoAuthorization()
            }
            .store(in: &cancellables)
        
        input.minusButtonTapped
            .sink { [weak self] index in
                self?.removePhoto(at: index)
            }
            .store(in: &cancellables)
        
        input.photosSelected
            .sink { [weak self] photoDatas in
                self?.addPhotos(photoDatas)
            }
            .store(in: &cancellables)
        
        input.nextButtonTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                let requirement = BouquetData.Requirement(
                    text: textInputSubject.value,
                    images: requirementPhotos.value
                )
                self.dataManager.setRequirement(requirement)
                self.showCustomizingSummaryViewSubject.send()
            }
            .store(in: &cancellables)
        
        return Output(
            updatePhotosData: requirementPhotos.eraseToAnyPublisher(),
            showPhotoView: showPhotoViewSubject.eraseToAnyPublisher(),
            showCustomizingSummaryView: showCustomizingSummaryViewSubject.eraseToAnyPublisher()
        )
    }
    
    private func addPhotos(_ photos: [Data]) {
        var currentPhotos = requirementPhotos.value
        let remainingCapacity = max(0, 3 - currentPhotos.count)
        currentPhotos.append(contentsOf: photos.prefix(remainingCapacity))
        requirementPhotos.send(currentPhotos)
    }
    
    private func removePhoto(at index: Int) {
        var currentPhotos = requirementPhotos.value
        
        guard index >= 0 && index < currentPhotos.count else { return }
        currentPhotos.remove(at: index)
        requirementPhotos.send(currentPhotos)
    }
    
    private func requestPhotoAuthorization() {
        photoAuthService.requestAuthorization { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.showPhotoViewSubject.send(requirementPhotos.value.count)
            case .failure:
                break
            }
        }
    }
}
