//
//  CustomizingSummaryViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 4/25/24.
//

import Foundation
import Combine

class CustomizingSummaryViewModel {
    
    // MARK: - Properties
    
    var customizingSummaryModel: CustomizingSummaryModel
    private let networkManager: NetworkManager
    let memberId: String?
    
    @Published var requestName = "꽃다발 요구서1"
    @Published var bouquetId: Int?
    @Published var networkError: NetworkError?
    @Published var imageUploadSuccess: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    init(
        customizingSummaryModel: CustomizingSummaryModel,
        networkManager: NetworkManager = .shared,
        keychainManager: KeychainManager = .shared
        
    ) {
        self.customizingSummaryModel = customizingSummaryModel
        self.networkManager = networkManager
        self.memberId = keychainManager.loadMemberId()
    }
    
    func submitCustomBouquet(id: String, DTO: PostCustomBouquetRequestDTO) {
        networkManager.createCustomBouquet(postCustomBouquetRequestDTO: DTO, memberID: id) { result in
            switch result {
            case .success(let DTO):
                self.bouquetId = PostCustomBouquetDTO.convertPostCustomBouquetDTOToBouquetId(DTO)
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
}
