//
//  FlowerSelectionViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/29/24.
//

import Foundation
import Combine

class FlowerSelectionViewModel {
    
    // MARK: - Properties
    
    private let purposeType: PurposeType
    var flowerKeywordModels: [FlowerKeywordModel] = []
    @Published var filteredModels: [FlowerKeywordModel] = []
    @Published var selectedFlowerModels: [FlowerKeywordModel] = []
    @Published var networkError: NetworkError?
    
    var cancellables = Set<AnyCancellable>()
    
    init(purposeType: PurposeType) {
        self.purposeType = purposeType
    }
    
    // MARK: - Functions
    
    func fetchFlowerKeyword(keywordId: String) {
        NetworkManager.shared.fetchFlowerKeyword(keywordId: keywordId) { result in
            switch result {
            case .success(let DTO):
                let models = FlowerKeywordDTO.convertFlowerKeywordDTOToModel(DTO)
                self.flowerKeywordModels = models
                self.filteredModels = models
            case .failure(let error):
                self.networkError = error
            }
        }
    }
    
    func getPurposeString() -> String {
        return purposeType.rawValue
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
            guard let image = $0.flowerImage,
                  let url = URL(string: image)
            else { return nil }
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
    
    func convertFlowerKeywordModelToFlower(with flowerKeywordModel: [FlowerKeywordModel]) -> [Flower] {
        return flowerKeywordModel.map { Flower(photo: $0.flowerImage, name: $0.flowerName, hashTag: $0.flowerKeyword) }
    }
}
