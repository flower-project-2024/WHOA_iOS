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
    case update(bouquetId: Int?)
    case customV2
}

final class CustomizingSummaryViewModel {
    
    // MARK: - Properties
    
    private let dataManager: BouquetDataManaging
    var customizingSummaryModel: CustomizingSummaryModel
    private let networkManager: NetworkManager
    var actionType: ActionType
    let memberId: String?
    
    @Published var requestTitle: String
    @Published var bouquetId: Int?
    @Published var networkError: NetworkError?
    @Published var imageUploadSuccess: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    
    init(
        dataManager: BouquetDataManaging = BouquetDataManager.shared,
        networkManager: NetworkManager = .shared,
        keychainManager: KeychainManager = .shared,
        actionType: ActionType = .create
    ) {
        self.dataManager = dataManager
        self.requestTitle = dataManager.getRequestTitle()
        self.customizingSummaryModel = .init(from: dataManager.getBouquet())
        self.networkManager = networkManager
        self.memberId = keychainManager.loadMemberId()
        self.actionType = dataManager.getActionType()
    }
    
    func saveBouquet(id: String, DTO: PostCustomBouquetRequestDTO) {
        switch actionType {
        case .create, .customV2:
            submitCustomBouquet(id: id, DTO: DTO)
        case .update(let bouquetId):
            guard let bouquetId = bouquetId else { return }
            deleteCustomBouquet(id: id, bouquetId: bouquetId, DTO: DTO)
        }
    }
    
    private func submitCustomBouquet(id: String, DTO: PostCustomBouquetRequestDTO) {
        networkManager.createCustomBouquet(postCustomBouquetRequestDTO: DTO, memberID: id) { result in
            switch result {
            case .success(let DTO):
                self.bouquetId = PostCustomBouquetDTO.convertPostCustomBouquetDTOToBouquetId(DTO)
            case .failure(let error):
                self.networkError = error
            }
        }
    }
    
    private func putCustomBouquet(id: String, bouquetId: Int, DTO: PostCustomBouquetRequestDTO) {
        networkManager.putCustomBouquet(postCustomBouquetRequestDTO: DTO, memberID: id, bouquetId: bouquetId) { result in
            switch result {
            case .success(let DTO):
                self.bouquetId = PostCustomBouquetDTO.convertPostCustomBouquetDTOToBouquetId(DTO)
            case .failure(let error):
                self.networkError = error
            }
        }
    }
    
    private func deleteCustomBouquet(id: String, bouquetId: Int, DTO: PostCustomBouquetRequestDTO) {
        NetworkManager.shared.deleteBouquet(memberID: id, bouquetId: bouquetId) { result in
            switch result {
            case .success(let _):
                self.submitCustomBouquet(id: id, DTO: DTO)
            case .failure(let error):
                self.networkError = error
            }
        }
    }
    
    func submitRequirementImages(id: String, bouquetId: Int, imageFiles: [ImageFile]?) {
        networkManager.postMultipartFiles(memberID: id, bouquetId: bouquetId, imageFiles: imageFiles) { result in
            switch result {
            case .success(let _):
                self.imageUploadSuccess = true
            case .failure(let error):
                self.networkError = error
            }
        }
    }
    
    func getRequestTitle(title: String?) {
        guard let title = title else { return }
        requestTitle = title
    }
}
