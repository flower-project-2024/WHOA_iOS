//
//  MyPageViewModel.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/4/24.
//

import UIKit

class BouquetListModel {
    
    // MARK: - Properties
    
    private var bouquetModelList: [BouquetModel] = [] {
        didSet {
            bouquetModelListDidChage?()
        }
    }
    
    var bouquetModelListDidChage: (() -> Void)?
    
    // MARK: - Functions
    
    func fetchAllBouquets(fromCurrentVC: UIViewController){
        guard let memberId = KeychainManager.shared.loadMemberId() else { return }
        print("member id: \(memberId)")
        NetworkManager.shared.fetchAllBouquets(memberId: memberId) { result in
            switch result {
            case .success(let model):
                self.bouquetModelList = model
            case .failure(let error):
                fromCurrentVC.showAlert(title: "네트워킹 오류", message: error.localizedDescription)
            }
        }
    }
    
    // 특정 요구서 1개 리턴
    func getBouquetModel(index: Int) -> BouquetModel {
        return bouquetModelList[index]
    }
    
    // 요구서 개수 리턴
    func getBouquetModelCount() -> Int {
        return bouquetModelList.count
    }
    
    func removeBouquet(withId bouquetId: Int) {
        bouquetModelList.removeAll { $0.bouquetId == bouquetId }
    }
}
