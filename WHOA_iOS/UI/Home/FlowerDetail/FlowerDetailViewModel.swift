//
//  FlowerDetailViewModel.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 6/20/24.
//

class FlowerDetailViewModel {
    
    // MARK: - Properties
    
    private var flowerDetailModel: FlowerDetailModel = FlowerDetailModel() {
        didSet {
            setMethodList()
            flowerDetailDidChange?()
        }
    }
    
    var flowerDetailDidChange: (() -> Void)?
    
    private var manageAndStorageMethodList: [String] = []
    
    // MARK: - Functions
    
    func fetchFlowerDetail(flowerId: Int){
        NetworkManager.shared.fetchFlowerDetail(flowerId: flowerId) { result in
            switch result {
            case .success(let model):
                self.flowerDetailModel = model
                print(self.flowerDetailModel)
            case .failure(let error):
                print("꽃 상세 조회 실패")
                //                let networkAlertController = self.networkErrorAlert(error)
                //
                //                DispatchQueue.main.async { [unowned self] in
                //                    fromCurrentVC.present(networkAlertController, animated: true)
                //                }
            }
        }
    }
    
    func getFlowerDetailModel() -> FlowerDetailModel{
        print(flowerDetailModel)
        return flowerDetailModel
    }
    
    func getFlowerName() -> String {
        return flowerDetailModel.flowerName!
    }
    
    func getFlowerOneLineDesc() -> String {
        return flowerDetailModel.flowerOneLineDescription!
    }
    
    func getFlowerDesc() -> String {
        return flowerDetailModel.flowerDescription!
    }
    
    /// 관리법, 보관법 칸에 들어갈 셀 개수 리턴
    func getFlowerManagementCellCount() -> Int {
        return manageAndStorageMethodList.count
    }
    
    func getFlowerMethodDetailAt(index: Int) -> [String] {
        var detailList: [String] = []
        manageAndStorageMethodList[index].split(separator: "\n").map {
            detailList.append(String($0))
        }
        return detailList
    }
    
    /// 관리법, 보관법 리스트 만들기
    private func setMethodList(){
        flowerDetailModel.managementMethod?.split(separator: "/").map {
            manageAndStorageMethodList.append(String($0))
        }
        
        if let storageMethod = flowerDetailModel.storageMethod {
            storageMethod.split(separator: "/").map {
                manageAndStorageMethodList.append(String($0))
            }
        }
        
        print("만들어진 관리, 보관법 리스트: \(manageAndStorageMethodList)")
    }
}
