//
//  RequestDetailViewModel.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 3/4/24.
//

import Foundation

final class RequestDetailViewModel {
    
    // MARK: - Properties
    
    var requestDetailModel: RequestDetailModel? {
        didSet {
            requestDetailModelDidChange?(requestDetailModel)
        }
    }
    var bouquetStatus: Bool? {
        didSet {
            bouquetStatusDidChange?(bouquetStatus)
        }
    }
    var imageUploadSuccess: Bool? {
        didSet {
            imageUploadSuccessDidChange?(imageUploadSuccess)
        }
    }
    
    private let requestTitle: String
    private let bouquetId: Int
    
    var requestDetailModelDidChange: ((RequestDetailModel?) -> Void)?
    var bouquetStatusDidChange: ((Bool?) -> Void)?
    var imageUploadSuccessDidChange: ((Bool?) -> Void)?
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
                        self.requestDetailModel = model
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
    
    func getRequestDetailModel() -> RequestDetailModel {
        return requestDetailModel!
    }
    
    /// 특정 꽃다발 요구서 제작 완료 상태로 변경하는 메소드
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
    
    /// 실제 꽃다발 이미지 업로드하는 메소드
    func postProductedBouquetImage(bouquetId: Int, imageFile: ImageFile) {
        guard let id = KeychainManager.shared.loadMemberId() else { return }
        
        NetworkManager.shared.postProductedBouquetImage(memberID: id, 
                                                        bouquetId: bouquetId, 
                                                        imageFile: [imageFile]
        ) { result in
            switch result {
            case .success(let dto):
                self.imageUploadSuccess = dto.success
            case .failure(let error):
                self.showError?(error)
            }
        }
    }
}
