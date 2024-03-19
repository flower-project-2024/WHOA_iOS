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
    private var photos = [UIImage?]()
    
    func getPhotos(photos: [UIImage?]) {
        self.photos = photos
    }
    
}
