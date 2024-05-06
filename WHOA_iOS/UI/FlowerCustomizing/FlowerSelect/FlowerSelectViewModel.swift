//
//  FlowerSelectViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/29/24.
//

import UIKit
import Combine

class FlowerSelectViewModel {
    
    // MARK: - Properties
    
    @Published var flowerKeywordModel: [FlowerKeywordModel] = []
    @Published var selectedFlowerModel: [FlowerKeywordModel] = []
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Functions
    
    func fetchFlowerKeyword(
        keywordId: String,
        completion: @escaping (Result<[FlowerKeywordModel], NetworkError>) -> Void
    ) {
        NetworkManager.shared.fetchFlowerKeyword(keywordId: keywordId) { result in
            completion(result)
        }
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
