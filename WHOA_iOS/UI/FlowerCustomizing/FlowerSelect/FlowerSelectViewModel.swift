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
    
    // FlowerKeywordModel
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
            selectedFlowerModel == model }) else { return }
        
        selectedFlowerModel.remove(at: idx)
    }
    
    // SelectedFlowerModel
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
        return selectedFlowerModel[idx]
    }
    
    func popSelectedFlowerModel(at index: Int) {
            if index >= 0 && index < selectedFlowerModel.count {
                selectedFlowerModel.remove(at: index)
            }
        }
    
    func findCellIndexPathRow(for model: FlowerKeywordModel) -> Int? {
        return flowerKeywordModel.firstIndex(where: { $0 == model })
    }
}
