//
//  FlowerSelectionViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/29/24.
//

import Foundation
import Combine

final class FlowerSelectionViewModel {
    
    // MARK: - Properties
    
    let dataManager: BouquetDataManaging
    private let purposeType: PurposeType
    let keyword = KeywordType.allCases
    var flowerKeywordModels: [FlowerKeywordModel] = []
    @Published var filteredModels: [FlowerKeywordModel] = []
    @Published var selectedFlowerModels: [FlowerKeywordModel] = []
    @Published var networkError: NetworkError?
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = BouquetDataManager.shared) {
        self.dataManager = dataManager
        self.purposeType = dataManager.getPurpose()
    }
    
    // MARK: - Functions
    
    func fetchFlowerKeyword(keywordId: Int = 0) {
        NetworkManager.shared.fetchFlowerKeyword(
            customizingPurposeId: purposeType.id,
            keywordId: keywordId
        ) { result in
            switch result {
            case .success(let DTO):
                let models = FlowerKeywordDTO.convertFlowerKeywordDTOToModel(DTO)
                self.flowerKeywordModels = models
                self.updateSelectedFlowerModels()
                self.filteredModels = models
            case .failure(let error):
                self.networkError = error
            }
        }
    }
    
    private func updateSelectedFlowerModels() {
        dataManager.getFlowers().forEach { flower in
            if let matchingFlower = flowerKeywordModels.first(where: { $0.id == flower.id }) {
                selectedFlowerModels.append(
                    FlowerKeywordModel(
                        id: matchingFlower.id,
                        flowerName: matchingFlower.flowerName,
                        flowerImage: matchingFlower.flowerImage,
                        flowerKeyword: matchingFlower.flowerKeyword,
                        flowerLanguage: matchingFlower.flowerLanguage
                    )
                )
            }
        }
    }
    
    func getPurposeString() -> String {
        return purposeType.rawValue
    }
    
    func popFlowerModel(model: FlowerKeywordModel) {
        guard let idx = selectedFlowerModels.firstIndex(where: { selectedFlowerModel in
            selectedFlowerModel == model }) else { return }
        
        selectedFlowerModels.remove(at: idx)
    }
    
    // SelectedFlowerModel
    func getSelectedFlowerModelCount() -> Int {
        return selectedFlowerModels.count
    }
    
    func getSelectedFlowerModelImagesURL() -> [String?] {
        return selectedFlowerModels.map { $0.flowerImage }
    }
    
    func pushFlowerModel(model: FlowerKeywordModel) {
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
    
    func convertFlowerKeywordModelToFlower(with flowerKeywordModel: [FlowerKeywordModel]) -> [BouquetData.Flower] {
        return flowerKeywordModel.map {
            BouquetData.Flower(
                id: $0.id,
                photo: $0.flowerImage,
                name: $0.flowerName,
                hashTag: convertLanguageStringToArray($0.flowerLanguage),
                flowerKeyword: $0.flowerKeyword
            )
        }
    }
    
    private func convertLanguageStringToArray(_ languageStr: String) -> [String] {
        let unifiedString = languageStr.replacingOccurrences(of: " · ", with: "\n")
        let languageArray = unifiedString.components(separatedBy: "\n")
        return languageArray
    }
}
