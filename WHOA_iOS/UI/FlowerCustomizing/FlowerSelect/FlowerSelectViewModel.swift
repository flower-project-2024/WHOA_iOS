//
//  FlowerSelectViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/29/24.
//

import UIKit

class FlowerSelectViewModel {
    
    private var flowerImages: [String] = [] {
        didSet {
            flowerImagesDidChage?(flowerImages)
        }
    }
    
    var flowerImagesDidChage: ((_ flowerImages: [String]) -> Void)?
    
    func addFlowerImage(imageString: String?) {
        guard let image = imageString else { return }
        
        flowerImages.append(image)
        
    }
    
    func goToNextVC(fromCurrentVC: UIViewController, animated: Bool) {
        let flowerReplacementVC = FlowerReplacementViewController()
        flowerReplacementVC.sheetPresentationController?.detents = [.medium()]
        
        fromCurrentVC.present(flowerReplacementVC, animated: true)
    }
}
