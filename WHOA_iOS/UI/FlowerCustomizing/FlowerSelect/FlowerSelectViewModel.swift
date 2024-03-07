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
    
    func pushFlowerImage(imageString: String?) {
        guard let image = imageString else { return }

        flowerImages.append(image)
        print(flowerImages)
    }
    
    func popFlowerImage(imageString: String?) {
        guard 
            let image = imageString,
            let index = flowerImages.firstIndex(of: image)
        else { return }
        
        flowerImages.remove(at: index)
        print(flowerImages)
    }
    
    func popFlowerImage(index: Int) {
        flowerImages.remove(at: index)
        print(flowerImages)
    }
    
    func getFlowerImagesCount() -> Int {
        return flowerImages.count
    }
    
    func getFlowerImage(at idx : Int) -> String {
        if idx <= flowerImages.count - 1 {
            return flowerImages[idx]
        }
        
        return ""
    }
    
    func goToNextVC(fromCurrentVC: UIViewController, animated: Bool) {
        let flowerReplacementVC = FlowerReplacementViewController()
        flowerReplacementVC.sheetPresentationController?.detents = [.medium()]
        
        fromCurrentVC.present(flowerReplacementVC, animated: true)
    }
}
