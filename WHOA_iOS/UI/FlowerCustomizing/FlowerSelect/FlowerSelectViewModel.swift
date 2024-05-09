//
//  FlowerSelectViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/29/24.
//

import Foundation
import Combine

class FlowerSelectViewModel {
    
    // MARK: - Properties
    
    var flowerKeywordModels: [FlowerKeywordModel] = []
    @Published var filteredModels: [FlowerKeywordModel] = []
    @Published var selectedFlowerModels: [FlowerKeywordModel] = []
    
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
    
    func popKeywordModel(model: FlowerKeywordModel) {
        guard let idx = selectedFlowerModels.firstIndex(where: { selectedFlowerModel in
            selectedFlowerModel == model }) else { return }
        
        selectedFlowerModels.remove(at: idx)
    }
    
    // SelectedFlowerModel
    func getSelectedFlowerModelCount() -> Int {
        return selectedFlowerModels.count
    }
    
    func getSelectedFlowerModelImagesURL() -> [URL?] {
        return selectedFlowerModels.map {
            let url = URL(string: $0.flowerImage) ?? nil
            return url
        }
    }
    
    func pushKeywordModel(model: FlowerKeywordModel) {
        selectedFlowerModels.append(model)
    }
    
    func getSelectedFlowerModel(idx: Int) -> FlowerKeywordModel {
        return selectedFlowerModels[idx]
    }
    
    func popSelectedFlowerModel(at index: Int) {
            if index >= 0 && index < selectedFlowerModels.count {
                selectedFlowerModels.remove(at: index)
            }
        }
    
    func findCellIndexPathRow(for model: FlowerKeywordModel) -> Int? {
        return filteredModels.firstIndex(where: { $0 == model })
    }
    
    // FilteredModels
    func filterModels(with hasTag: String) {
        filteredModels = hasTag == "전체" ?
        flowerKeywordModels :
        flowerKeywordModels.filter { $0.flowerKeyword.contains(hasTag) }
    }
    
    func getFilterdModelsCount() -> Int {
        return filteredModels.count
    }
    
    func getFilterdModel(idx: Int) -> FlowerKeywordModel {
        return filteredModels[idx]
    }
}
