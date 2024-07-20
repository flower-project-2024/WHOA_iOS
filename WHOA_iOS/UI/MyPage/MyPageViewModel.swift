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
            bouquetModelListDidChage?()
        }
    }
    
    var bouquetModelListDidChage: (() -> Void)?
    
    // MARK: - Functions
    
    func fetchAllBouquets(fromCurrentVC: UIViewController) {
        guard let memberId = KeychainManager.shared.loadMemberId() else { return }
        print("member id: \(memberId)")
        NetworkManager.shared.fetchAllBouquets(memberId: memberId) { result in
            switch result {
            case .success(let model):
                self.bouquetModelList = model
            case .failure(let error):
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async {
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
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
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}
