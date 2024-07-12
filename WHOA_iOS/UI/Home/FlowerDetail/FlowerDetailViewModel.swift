//
//  FlowerDetailViewModel.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 6/20/24.
//

import UIKit

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
    
    func fetchFlowerDetail(flowerId: Int, fromCurrentVC: UIViewController){
        NetworkManager.shared.fetchFlowerDetail(flowerId: flowerId) { result in
            switch result {
            case .success(let model):
                self.flowerDetailModel = model
            case .failure(let error):
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async { [unowned self] in
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    func getFlowerDetailModel() -> FlowerDetailModel{
        print(flowerDetailModel)
        return flowerDetailModel
    }
    
    func getFlowerImageCount() -> Int {
        return flowerDetailModel.flowerImages!.count
    }
    
    func getFlowerImages() -> [String] {
        return flowerDetailModel.flowerImages!
    }
    
    func getFlowerName() -> String {
        return flowerDetailModel.flowerName ?? "꽃"
    }
    
    func getFlowerOneLineDesc() -> String {
        return flowerDetailModel.flowerOneLineDescription!
    }
    
    func getFlowerDesc() -> String {
        return flowerDetailModel.flowerDescription!
    }
    
    func getBirthFlowerDates() -> [String]? {
        return flowerDetailModel.birthFlower?.split(separator: ",").map({
            String($0)
        })
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
    
    func getFlowerExpressionsCount() -> Int {
        return flowerDetailModel.flowerExpressions?.count ?? 0
    }
    
    func getFlowerExpressionAt(index: Int) -> FlowerExpression {
        return flowerDetailModel.flowerExpressions![index]
    }
    
    func getFlowerColors() -> [String] {
        var colorList: [String] = []
        
        if let expressions = flowerDetailModel.flowerExpressions {
            expressions.map {
                colorList.append($0.flowerColor!)
            }
        }
        return colorList
    }
    
    func getFlowerLanguagesAt(index: Int) -> String {
        if let expressions = flowerDetailModel.flowerExpressions {
            return expressions[index].flowerLanguage!
        }
        return ""
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
    }
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}
