//
//  FlowerSelectViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/29/24.
//

import UIKit

class FlowerSelectViewModel {
    
    // MARK: - Properties
    
    private var flowerKeywordModel: [FlowerKeywordModel] = [] {
        didSet {
            flowerKeywordModelDidChage?()
        }
    }
    
    private var selectedFlowerModel: [FlowerKeywordModel] = [] {
        didSet {
            print(selectedFlowerModel)
            selectedFlowerModelDidChage?(selectedFlowerModel)
        }
    }
    
    var flowerKeywordModelDidChage: (() -> Void)?
    var selectedFlowerModelDidChage: ((_ model: [FlowerKeywordModel]) -> Void)?
    
    // MARK: - Functions
    
    func fetchFlowerKeyword(fromCurrentVC: UIViewController) {
        NetworkManager.shared.fetchFlowerKeyword(keywordId: "0") { result in
            switch result {
            case .success(let models):
                self.flowerKeywordModel = models
            case .failure(let error):
                let networkAlertController = self.networkErrorAlert(error)
                
                DispatchQueue.main.async { [unowned self] in
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        }
    }
    
    private func networkErrorAlert(_ error: NetworkError) -> UIAlertController {
        let alertController = UIAlertController(title: "네트워크 에러 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
    
    func getFlowerKeywordModel(idx: Int) -> FlowerKeywordModel {
        return flowerKeywordModel[idx]
    }
    
    func getFlowerKeywordModelCount() -> Int {
        return flowerKeywordModel.count
    }
    
    func pushKeywordModel(model: FlowerKeywordModel) {
        selectedFlowerModel.append(model)
    }
    
    func popKeywordModel(model: FlowerKeywordModel) {
        guard let idx = selectedFlowerModel.firstIndex(where: { selectedFlowerModel in
            selectedFlowerModel.flowerName == model.flowerName
        }) else { return }
        
        selectedFlowerModel.remove(at: idx)
    }
    
    func getSelectedFlowerModelCount() -> Int {
        return selectedFlowerModel.count
    }
    
    func getSelectedFlowerModelImagesURL() -> [URL?] {
        return selectedFlowerModel.map {
            let url = URL(string: $0.flowerImage) ?? nil
            return url
        }
    }
    
    func getSelectedFlowerModel(idx: Int) -> FlowerKeywordModel {
        return flowerKeywordModel[idx]
    }
    
    func findCellIndexPathRow(for flowerName: String) -> Int? {
        return flowerKeywordModel.firstIndex(where: { $0.flowerName == flowerName })
    }
    
    func goToNextVC(fromCurrentVC: UIViewController, animated: Bool) {
        let flowerReplacementVC = AlternativesViewController()
        flowerReplacementVC.sheetPresentationController?.detents = [.medium()]
        
        fromCurrentVC.present(flowerReplacementVC, animated: true)
    }
}
