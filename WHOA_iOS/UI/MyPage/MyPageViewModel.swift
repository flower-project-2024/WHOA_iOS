//
//  MyPageViewModel.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/4/24.
//

import UIKit

final class BouquetListModel {
    
    // MARK: - Properties
    
    private var bouquetModelList: [BouquetModel] = [] {
        didSet {
            bouquetModelListDidChange?()
        }
    }
    
    var bouquetModelListDidChange: (() -> Void)?
    
    // MARK: - Functions
    
    func fetchAllBouquets(fromCurrentVC: UIViewController) {
        guard let memberId = KeychainManager.shared.loadMemberId() else { return }
        NetworkManager.shared.fetchAllBouquets(memberId: memberId) { result in
            switch result {
            case .success(let model):
                self.bouquetModelList = model
            case .failure(let error):
                fromCurrentVC.showAlert(title: "네트워킹 오류", message: error.localizedDescription)
            }
        }
    }
    
    func getBouquetModel(index: Int) -> BouquetModel {
        return bouquetModelList[index]
    }
    
    func getBouquetModelCount() -> Int {
        return bouquetModelList.count
    }
    
    func removeBouquet(withId bouquetId: Int) {
        bouquetModelList.removeAll { $0.bouquetId == bouquetId }
    }
    
    func getBouquetsByType(_ type: BouquetStatusType) -> [BouquetModel] {
        switch type {
        case .producted:
            return bouquetModelList.filter { $0.bouquetStatus == .producted }
        case .saved:
            return bouquetModelList.filter { $0.bouquetStatus == .saved }
        default:
            return bouquetModelList
        }
    }
    
    func isBouquetModelListEmpty() -> Bool {
        return bouquetModelList.isEmpty
    }
    
    func updateBouquetName(withId id: Int, newName: String) {
        if let index = bouquetModelList.firstIndex(where: { $0.bouquetId == id }) {
            bouquetModelList[index].bouquetTitle = newName
            bouquetModelListDidChange?()
        }
    }
}
