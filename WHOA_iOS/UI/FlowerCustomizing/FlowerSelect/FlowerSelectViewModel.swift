//
//  FlowerSelectViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/29/24.
//

import UIKit

class FlowerSelectViewModel {
    
    // MARK: - Properties
    
    private var flowerKeywordModel: [FlowerKeywordModel] = [] {
        didSet {
            print(flowerKeywordModel)
        }
    }
    
    private var flowerImages: [String] = [] {
        didSet {
            flowerImagesDidChage?(flowerImages)
        }
    }
    
    var flowerImagesDidChage: ((_ flowerImages: [String]) -> Void)?
    
    // MARK: - Functions
    
    func fetchFlowerKeyword(fromCurrentVC: UIViewController) {
        NetworkManager.shared.fetchFlowerKeyword { result in
            switch result {
            case .success(let models):
                self.flowerKeywordModel = models
            case .failure(let error):
                let networkAlertController = self.networkErrorAlert(error)
                
                DispatchQueue.main.async { [unowned self] in
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    private func networkErrorAlert(_ error: NetworkError) -> UIAlertController {
        let alertController = UIAlertController(title: "네트워크 에러 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
    
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
