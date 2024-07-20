//
//  FlowerSearchViewModel.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/12/24.
//

import UIKit

class FlowerSearchViewModel {
    
    // MARK: - Properties
    
    private var flowerSearchList: [FlowerSearchModel] = [] {
        didSet {
            flowerSearchListDidChange?()
        }
    }
    
    var flowerSearchListDidChange: (() -> Void)?
    
    // MARK: - Functions
    
    func fetchFlowersForSearch(fromCurrentVC: UIViewController) {
        NetworkManager.shared.fetchFlowersForSearch { result in
            switch result {
            case .success(let model):
                self.flowerSearchList = model
            case .failure(let error):
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async { [unowned self] in
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    func getFlowerSearchModel(index: Int) -> FlowerSearchModel {
        return flowerSearchList[index]
    }
    
    func getFlowerSearchListCount() -> Int {
        return flowerSearchList.count
    }
    
    func getFilteredFlowers(searchedText: String) -> [FlowerSearchModel] {
        return flowerSearchList.filter { $0.flowerName.localizedCaseInsensitiveContains(searchedText) }
    }
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}
