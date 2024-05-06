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
    
    func fetchAllBouquets(){
        NetworkManager.shared.fetchAllBouquets { result in
            switch result {
            case .success(let model):
                self.bouquetModelList = model
            case .failure(let error):
                print("요구서 리스트 요청 실패")
                //                let networkAlertController = self.networkErrorAlert(error)
                //
                //                DispatchQueue.main.async { [unowned self] in
                //                    fromCurrentVC.present(networkAlertController, animated: true)
                //                }
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
}
