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
    
    func fetchFlowersForSearch(fromCurrentVC: UIViewController){
        NetworkManager.shared.fetchFlowersForSearch { result in
            switch result {
            case .success(let model):
                self.flowerSearchList = model
            case .failure(let error):
                fromCurrentVC.showAlert(title: "네트워킹 오류", message: error.localizedDescription)
            }
        }
    }
    
    // 꽃 1개 리턴 (인덱스에 해당하는)
    func getFlowerSearchModel(index: Int) -> FlowerSearchModel {
        return flowerSearchList[index]
    }
    
    func getFlowerSearchListCount() -> Int {
        return flowerSearchList.count
    }
    
    func getFilteredFlowers(searchedText: String) -> [FlowerSearchModel] {
        return flowerSearchList.filter { $0.flowerName.localizedCaseInsensitiveContains(searchedText) }
    }
}
