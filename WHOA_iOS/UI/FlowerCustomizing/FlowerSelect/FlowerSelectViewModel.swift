//
//  FlowerSelectViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/29/24.
//

import UIKit

class FlowerSelectViewModel {
    
    func goToNextVC(fromCurrentVC: UIViewController, animated: Bool) {
        let flowerReplacementVC = FlowerReplacementViewController()
        flowerReplacementVC.sheetPresentationController?.detents = [.medium()]
        
        fromCurrentVC.present(flowerReplacementVC, animated: true)
    }
}
