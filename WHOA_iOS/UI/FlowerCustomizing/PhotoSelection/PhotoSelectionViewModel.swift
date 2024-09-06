//
//  PhotoSelectionViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 3/14/24.
//

import Foundation

final class PhotoSelectionViewModel {
    
    // MARK: - Properties
    
    let dataManager: BouquetDataManaging
    let authService = MyPhotoAuthService()
    var photoSelectionModel: PhotoSelectionModel
    
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = BouquetDataManager.shared) {
        self.dataManager = dataManager
        let requirement = dataManager.getRequirement()
        photoSelectionModel = PhotoSelectionModel(photoDatas: requirement.images, text: requirement.text)
    }
    
    // MARK: - Functions
    
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
