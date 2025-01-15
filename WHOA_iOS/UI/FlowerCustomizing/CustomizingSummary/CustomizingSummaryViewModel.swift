//
//  CustomizingSummaryViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 4/25/24.
//

import Foundation
import Combine


enum ActionType: Equatable {
    case create
    case update(bouquetId: Int)
    case customV2
}

final class CustomizingSummaryViewModel: ViewModel {
    
    // MARK: - Properties
    
    struct Input {
        let textInput: AnyPublisher<String, Never>
        let nextButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let setupRequestDetailView: AnyPublisher<BouquetData, Never>
        let setupRequestTitle: AnyPublisher<String, Never>
        let networkError: AnyPublisher<NetworkError?, Never>
        let showSaveAlertView: AnyPublisher<Void, Never>
    }
    
    private let dataManager: BouquetDataManaging
    private let keychainManager: KeychainAccessible
    private let networkManager: NetworkManager
    private let actionType: ActionType
    
    private let bouquetDataSubject: CurrentValueSubject<BouquetData, Never>
    private let requestTitleSubject: CurrentValueSubject<String, Never>
    private let networkErrorSubject = PassthroughSubject<NetworkError?, Never>()
    private let showSaveAlertViewSubject = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    
    init(
        dataManager: BouquetDataManaging = BouquetDataManager.shared,
        keychainManager: KeychainAccessible = KeychainManager.shared,
        networkManager: NetworkManager = .shared,
        actionType: ActionType = .create
    ) {
        self.dataManager = dataManager
        self.keychainManager = keychainManager
        self.networkManager = networkManager
        self.actionType = dataManager.getActionType()
        requestTitleSubject = .init(dataManager.getRequestTitle())
        bouquetDataSubject = .init(dataManager.getBouquet())
    }
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        let setupRequestDetailViewPublisher = Just(requestTitleSubject.value)
        
        input.textInput
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .assign(to: \.value, on: requestTitleSubject)
            .store(in: &cancellables)
        
        input.nextButtonTapped
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self, let id = keychainManager.loadMemberId() else { return }
                let updatedBouquetData = self.updateBouquetData()
                let imageFiles = self.convertImagesToFiles(from: updatedBouquetData)
                
                self.saveBouquet(
                    id: id,
                    DTO: PostCustomBouquetRequestDTO(from: updatedBouquetData),
                    imageFiles: imageFiles
                )
            }
            .store(in: &cancellables)
        
        return Output(
            setupRequestDetailView: bouquetDataSubject.eraseToAnyPublisher(),
            setupRequestTitle: setupRequestDetailViewPublisher.eraseToAnyPublisher(),
            networkError: networkErrorSubject.eraseToAnyPublisher(),
            showSaveAlertView: showSaveAlertViewSubject.eraseToAnyPublisher()
        )
    }
    
    private func saveBouquet(id: String, DTO: PostCustomBouquetRequestDTO, imageFiles: [ImageFile]?) {
        switch actionType {
        case .create, .customV2:
            postCustomBouquet(id: id, DTO: DTO, imageFiles: imageFiles)
        case .update(let bouquetId):
            putCustomBouquet(id: id, bouquetId: bouquetId, DTO: DTO, imageFiles: imageFiles)
        }
    }
    
    private func postCustomBouquet(id: String, DTO: PostCustomBouquetRequestDTO, imageFiles: [ImageFile]?) {
        networkManager.createCustomBouquet(
            memberID: id,
            postCustomBouquetRequestDTO: DTO,
            imageFiles: imageFiles) { result in
                switch result {
                case .success(_):
                    self.showSaveAlertViewSubject.send()
                case .failure(let error):
                    self.networkErrorSubject.send(error)
                }
            }
    }
    
    private func putCustomBouquet(id: String, bouquetId: Int, DTO: PostCustomBouquetRequestDTO,  imageFiles: [ImageFile]?) {
        networkManager.putCustomBouquet(bouquetId: bouquetId, memberID: id, postCustomBouquetRequestDTO: DTO, imageFiles: imageFiles) { result in
            switch result {
            case .success(_):
                self.showSaveAlertViewSubject.send()
            case .failure(let error):
                self.networkErrorSubject.send(error)
            }
        }
    }
    
    private func updateBouquetData() -> BouquetData {
        var bouquetData = bouquetDataSubject.value
        bouquetData.requestTitle = requestTitleSubject.value.isEmpty
        ? "꽃다발 요구서"
        : requestTitleSubject.value
        return bouquetData
    }
    
    private func convertImagesToFiles(from bouquetData: BouquetData) -> [ImageFile] {
        return bouquetData.requirement.images.map {
            $0.toImageFile(filename: "RequirementImage")
        }
    }
}
