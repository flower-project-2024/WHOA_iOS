//
//  RequestDetailViewModel.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/4/24.
//

import Foundation

final class RequestDetailViewModel {
    
    // MARK: - Properties
    
    var customizingSummaryModel: CustomizingSummaryModel? {
        didSet {
            customizingSummaryModelDidChaged?(customizingSummaryModel)
        }
    }
    var bouquetStatus: Bool? {
        didSet {
            bouquetStatusDidChange?(bouquetStatus)
        }
    }
    
    private let requestTitle: String
    private let bouquetId: Int
    
    var customizingSummaryModelDidChaged: ((CustomizingSummaryModel?) -> Void)?
    var bouquetStatusDidChange: ((Bool?) -> Void)?
    var showError: ((NetworkError) -> Void)?
    
    // MARK: - Init
    
    init(requestTitle: String, bouquetId: Int) {
        self.requestTitle = requestTitle
        self.bouquetId = bouquetId
    }
    
    // MARK: - Functions
    
    func fetchBouquetDetail(bouquetId: Int) {
        guard let id = KeychainManager.shared.loadMemberId() else { return }
        
        NetworkManager.shared.fetchBouquetDetail(memberID: id, bouquetId: bouquetId) { result in
            switch result {
            case .success(let dto):
                BouquetDetailDTO.convertBouquetDetailDTOToModel(dto) { model in
                    if let model = model {
                        self.customizingSummaryModel = model
                    }
                }
            case .failure(let error):
                self.showError?(error)
            }
        }
    }
    
    func getRequestTitle() -> String {
        return requestTitle
    }
    
    func getBouquetId() -> Int {
        return bouquetId
    }
    
    func patchBouquetStatus() {
        guard let id = KeychainManager.shared.loadMemberId() else { return }
        
        NetworkManager.shared.patchBouquetStatus(memberId: id, bouquetId: bouquetId) { result in
            switch result {
            case .success(let dto):
                self.bouquetStatus = dto.success
            case .failure(let error):
                self.showError?(error)
            }
        }
    }
}
