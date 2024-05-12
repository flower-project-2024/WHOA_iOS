//
//  FlowerSearchViewModel.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/12/24.
//

class FlowerSearchViewModel {
    
    // MARK: - Properties
    
    private var flowerSearchList: [FlowerSearchModel] = [] {
        didSet {
            flowerSearchListDidChange?()
        }
    }
    
    var flowerSearchListDidChange: (() -> Void)?
    
    // MARK: - Functions
    
    func fetchFlowersForSearch(){
        NetworkManager.shared.fetchFlowersForSearch { result in
            switch result {
            case .success(let model):
                self.flowerSearchList = model
            case .failure(let error):
                print("검색을 위한 꽃 정보 조회 실패")
                //                let networkAlertController = self.networkErrorAlert(error)
                //
                //                DispatchQueue.main.async { [unowned self] in
                //                    fromCurrentVC.present(networkAlertController, animated: true)
                //                }
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
