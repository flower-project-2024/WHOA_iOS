//
//  FlowerSelectionViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/29/24.
//

import Foundation
import Combine

final class FlowerSelectionViewModel: ViewModel {
    
    // MARK: - Properties
    
    struct Input {
        let keywordSelected: AnyPublisher<KeywordType, Never>
        let flowerSelected: AnyPublisher<Int, Never>
        let minusButtonTapped: AnyPublisher<Int, Never>
        let nextButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let updateFlowerList: AnyPublisher<Void, Never>
        let selectedFlowers: AnyPublisher<[FlowerKeywordModel], Never>
        let networkError: AnyPublisher<NetworkError?, Never>
        let deselectedFlower: AnyPublisher<Int, Never>
        let nextButtonEnabled: AnyPublisher<Bool, Never>
        let showAlternativeView: AnyPublisher<Void, Never>
    }
    
    private let dataManager: BouquetDataManaging
    private let purposeType: PurposeType
    private let flowerModelsSubject = CurrentValueSubject<[FlowerKeywordModel], Never>([])
    private let filteredFlowerModelsSubject = CurrentValueSubject<[FlowerKeywordModel], Never>([])
    private var selectedFlowerModelsSubject = CurrentValueSubject<[FlowerKeywordModel], Never>([])
    private let updateFlowerListSubject = PassthroughSubject<Void, Never>()
    private let unselectedFlowerSubject = PassthroughSubject<Int, Never>()
    private let networkErrorSubject = PassthroughSubject<NetworkError?, Never>()
    private let showAlternativeViewSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = BouquetDataManager.shared) {
        self.dataManager = dataManager
        self.purposeType = dataManager.getPurpose()
        initSelectedFlowers()
    }
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        input.keywordSelected
            .sink { [weak self] keyword in
                guard let self = self else { return }
                self.filterModels(with: keyword)
                self.updateFlowerListSubject.send()
            }
            .store(in: &cancellables)
        
        input.flowerSelected
            .sink { [weak self] index in
                self?.updateSelectedFlowers(index: index, isUnselecting: false)
            }
            .store(in: &cancellables)
        
        input.minusButtonTapped
            .sink { [weak self] index in
                self?.updateSelectedFlowers(index: index, isUnselecting: true)
            }
            .store(in: &cancellables)
        
        let nextButtonEnabled = selectedFlowerModelsSubject
            .map { $0.count > 0 }
        
        input.nextButtonTapped
            .sink { [weak self] _ in
                guard let self = self else { return }
                dataManager.setFlowers(convertFlowerKeywordModelToFlower(with: selectedFlowerModelsSubject.value))
                self.showAlternativeViewSubject.send()
            }
            .store(in: &cancellables)
        
        return Output(
            updateFlowerList: updateFlowerListSubject.eraseToAnyPublisher(),
            selectedFlowers: selectedFlowerModelsSubject.eraseToAnyPublisher(),
            networkError: networkErrorSubject.eraseToAnyPublisher(),
            deselectedFlower: unselectedFlowerSubject.eraseToAnyPublisher(),
            nextButtonEnabled: nextButtonEnabled.eraseToAnyPublisher(),
            showAlternativeView: showAlternativeViewSubject.eraseToAnyPublisher()
        )
        
    }
    
    private func filterModels(with keyword: KeywordType) {
        let filteredModels = keyword == .all
        ? flowerModelsSubject.value
        : flowerModelsSubject.value.filter { $0.flowerKeyword.contains(keyword.rawValue) }
        
        filteredFlowerModelsSubject.send(filteredModels)
    }
    
    private func updateSelectedFlowers(index: Int, isUnselecting: Bool) {
        var currentModels = selectedFlowerModelsSubject.value
        let selectedFlower = isUnselecting ? currentModels[index] : filteredFlowerModelsSubject.value[index]

        if isUnselecting {
            removeSelectedFlower(at: index, in: &currentModels, selectedFlower: selectedFlower)
        } else {
            addOrRemoveFlower(selectedFlower, in: &currentModels)
        }
        
        selectedFlowerModelsSubject.send(currentModels)
    }
    
    /// 마이너스 버튼으로 삭제하는 메서드
    private func removeSelectedFlower(
        at index: Int,
        in models: inout [FlowerKeywordModel],
        selectedFlower: FlowerKeywordModel
    ) {
        guard index < models.count else { return }
        guard let tableViewIndex = filteredFlowerModelsSubject.value.firstIndex(where: { $0.id == selectedFlower.id }) else { return }
        models.remove(at: index)
        unselectedFlowerSubject.send(tableViewIndex)
    }
    
    
    /// 테이블 뷰 셀을 클릭해서 데이터를 추가 or 삭제하는 메서드
    private func addOrRemoveFlower(
        _ flower: FlowerKeywordModel,
        in models: inout [FlowerKeywordModel]
    ) {
        if let currentIndex = models.firstIndex(where: { $0.id == flower.id }) {
            models.remove(at: currentIndex)
        } else if models.count < 3 {
            models.append(flower)
        }
    }
    
    func fetchFlowerKeyword(keywordId: Int = 0) {
        let colorScheme = dataManager.getColorScheme()
        NetworkManager.shared.fetchFlowerKeyword(
            customizingPurposeId: purposeType.id,
            keywordId: keywordId,
            selectedColors: combinedColors(colorScheme.pointColor, colorScheme.colors)
        ) { [weak self] result in
            self?.handleNetworkResponse(result)
        }
    }
    
    private func handleNetworkResponse(_ result: Result<FlowerKeywordDTO, NetworkError>) {
        switch result {
        case .success(let DTO):
            let models = FlowerKeywordDTO.convertFlowerKeywordDTOToModel(DTO)
            flowerModelsSubject.send(models)
            filteredFlowerModelsSubject.send(models)
            updateFlowerListSubject.send()
        case .failure(let error):
            networkErrorSubject.send(error)
        }
    }
    
    func getPurpose() -> PurposeType {
        return purposeType
    }
    
    var flowerModelCount: Int {
        filteredFlowerModelsSubject.value.count
    }
    
    var selectedFlowerModelCount: Int {
        selectedFlowerModelsSubject.value.count
    }
    
    func getFlowerModel(index: Int) -> FlowerKeywordModel {
        return filteredFlowerModelsSubject.value[index]
    }
    
    func isModelSelected(_ model: FlowerKeywordModel) -> Bool {
        return selectedFlowerModelsSubject.value.contains(where: { $0.id == model.id })
    }
    
    private func initSelectedFlowers() {
        let flowers = dataManager.getFlowers().map { flower in
            FlowerKeywordModel(
                id: flower.id,
                flowerName: flower.name,
                flowerImage: flower.photo,
                flowerKeyword: flower.flowerKeyword,
                flowerLanguage: FlowerKeywordDTO.formatFlowerLanguage(flower.hashTag.joined(separator: ", "))
            )
        }
        selectedFlowerModelsSubject.send(flowers)
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
    
    private func combinedColors(_ pointColor: String?, _ colors: [String]) -> String {
        var combinedColors = colors
        
        if let pointColor = pointColor {
            combinedColors.insert(pointColor, at: 0)
        }
        
        let joined = combinedColors.joined(separator: "%2C") // 콤마(,)
        return joined.replacingOccurrences(of: "#", with: "%23")
    }
}
