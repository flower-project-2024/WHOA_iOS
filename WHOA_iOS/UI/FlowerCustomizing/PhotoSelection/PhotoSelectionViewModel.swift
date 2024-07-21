//
//  PhotoSelectionViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 3/14/24.
//

import UIKit

final class PhotoSelectionViewModel {
    
    // MARK: - Properties
    
    let authService = MyPhotoAuthService()
    
    var photos = [UIImage?]()
    private var photoSelectionModel = PhotoSelectionModel(imageFiles: [], text: nil)
    
    // MARK: - Functions
    
    func getPhotoSelectionModel() -> PhotoSelectionModel {
        return photoSelectionModel
    }
    
    func addPhotos(photos: [UIImage?]) {
        self.photos.append(contentsOf: photos)
    }
    
    func getPhoto(idx: Int) -> UIImage? {
        if idx >= photos.count {
            return nil
        }
        
        return photos[idx]
    }
    
    func getPhotosArray() -> [UIImage?] {
        return photos
    }
    
    func getPhotosCount() -> Int {
        return photos.count
    }
    
    func convertPhotosToBase64() {
        photoSelectionModel.imageFiles.removeAll()
        
        for i in 0..<photos.count {
            if let pnaData = photos[i]?.pngData() {
                let imageFile = ImageFile(filename: "RequirementImage\(i+1)", data: pnaData, type: "image/png")
                photoSelectionModel.imageFiles.append(imageFile)
            }
        }
    }
    
    func updateText(_ text: String) {
        photoSelectionModel.text = text
    }
    
}
