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
    
    private var selectedFlowerExpression: FlowerExpression? = nil {
        didSet {
            colorChipDidChanged?()
        }
    }
    
    var colorChipDidChanged: (() -> Void)?
    var flowerDetailDidChange: (() -> Void)?
    
    private var manageAndStorageMethodList: [String] = []
    
    // MARK: - Functions
    
    func fetchFlowerDetail(flowerId: Int, fromCurrentVC: UIViewController) {
        NetworkManager.shared.fetchFlowerDetail(flowerId: flowerId) { result in
            switch result {
            case .success(let model):
                self.flowerDetailModel = model
            case .failure(let error):
                fromCurrentVC.showAlert(title: "네트워킹 오류", message: error.localizedDescription)
            }
        }
    }
    
    func getFlowerDetailModel() -> FlowerDetailModel {
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
    
    func setFlowerExpression(hexString: String) {
        let flowerExpression = flowerDetailModel.flowerExpressions?
            .filter{ $0.flowerColor?.lowercased() == hexString }
            .first
        selectedFlowerExpression = flowerExpression
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
    
    func getSelectedFlowerLanguageCount() -> Int {
        return selectedFlowerExpression?.flowerLanguage?.components(separatedBy: ",").count ?? 0
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
        if let language = selectedFlowerExpression?.flowerLanguage {
            let languageArray = language
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
            return languageArray[index]
        }
        return ""
    }
    
    /// 관리법, 보관법 리스트 만들기
    private func setMethodList() {
        flowerDetailModel.managementMethod?.split(separator: "/").map {
            manageAndStorageMethodList.append(String($0))
        }
        
        if let storageMethod = flowerDetailModel.storageMethod {
            storageMethod.split(separator: "/").map {
                manageAndStorageMethodList.append(String($0))
            }
        }
    }
    
    func getColorScheme(index: Int) -> BouquetData.ColorScheme {
        guard let hexColor = flowerDetailModel.flowerExpressions?[index].flowerColor else { return BouquetData.ColorScheme(numberOfColors: .none, pointColor: nil, colors: []) }
        return BouquetData.ColorScheme(numberOfColors: .oneColor, pointColor: nil, colors: [hexColor])
    }
    
    func getBouquetFlower(index: Int) -> [BouquetData.Flower] {
        let flowerExpression = flowerDetailModel.flowerExpressions?[index]
        let flower = BouquetData.Flower(
            id: flowerExpression?.flowerExpressionId,
            photo: flowerExpression?.flowerImageUrl,
            name: flowerDetailModel.flowerName ?? "",
            hashTag: flowerExpression?.flowerLanguage?.components(separatedBy: ",").compactMap { $0.trimmingCharacters(in: .whitespaces) } ?? [],
            flowerKeyword: []
        )
        return [flower]
    }

}
