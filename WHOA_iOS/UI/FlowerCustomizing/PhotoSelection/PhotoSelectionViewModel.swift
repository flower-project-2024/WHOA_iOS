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
        let nextButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let showCustomizingSummaryView: AnyPublisher<Void, Never>
    }
    
    let dataManager: BouquetDataManaging
    let photoAuthService: PhotoAuthService
    var photoSelectionModel: PhotoSelectionModel
    private let showCustomizingSummaryViewSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Initialize
    
    init(
        dataManager: BouquetDataManaging = BouquetDataManager.shared,
        authService: PhotoAuthService = MyPhotoAuthService()
    ) {
        self.photoAuthService = authService
        self.dataManager = dataManager
        let requirement = dataManager.getRequirement()
        photoSelectionModel = PhotoSelectionModel(photoDatas: requirement.images, text: requirement.text)
    }
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        return Output(
            showCustomizingSummaryView: showCustomizingSummaryViewSubject.eraseToAnyPublisher()
        )
    }
    
    func getPhotoSelectionModel() -> PhotoSelectionModel {
        return photoSelectionModel
    }
    
    func addPhotos(photos: [Data]) {
        photoSelectionModel.photoDatas.append(contentsOf: photos)
    }
    
    func getPhoto(idx: Int) -> Data {
        return photoSelectionModel.photoDatas[idx]
    }
    
    func getPhotosArray() -> [Data] {
        return photoSelectionModel.photoDatas
    }
    
    func getPhotosCount() -> Int {
        return photoSelectionModel.photoDatas.count
    }
    
    func updateText(_ text: String) {
        photoSelectionModel.text = text
    }
    
}
