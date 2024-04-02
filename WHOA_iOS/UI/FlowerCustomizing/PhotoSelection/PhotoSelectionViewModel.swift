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
    
}
