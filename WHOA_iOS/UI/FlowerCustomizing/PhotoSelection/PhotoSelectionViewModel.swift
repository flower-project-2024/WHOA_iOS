//
//  PhotoSelectionViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 3/14/24.
//

import UIKit

class PhotoSelectionViewModel {
    
    // MARK: - Properties
    
    let authService = MyPhotoAuthService()
    
    var photos = [UIImage?]()
    
    func setupPhotos(photos: [UIImage?]) {
        self.photos = photos
    }
    
    func getPhotos() -> [UIImage?] {
        return photos
    }
    
    func getPhotosCount() -> Int {
        return photos.count
    }
    
}
