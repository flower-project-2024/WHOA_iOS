//
//  NetworkManager.swift
//  WHOA_iOS
//
//  Created by KSH on 2/23/24.
//

import Foundation

// 3. NetworkService 함수를 이용해서 NetworkManager에 네트워킹 요청 함수 구현
// 실직적으로 네트워킹을 할 함수를 선언하는 곳
final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    /// 요구서 전체를 조회하는 함수입니다.
    func fetchAllBouquets(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<[BouquetModel], NetworkError>) -> Void
    ) {
        let bouquetAllAPI = BouquetAllAPI()
        networkService.request(bouquetAllAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(BouquetAllDTO.convertBouquetAllDTOToModel(DTO: DTO)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// 키워드별 꽃 데이터를 받아오는 함수입니다.
    /// - Parameters:
    /// - keywordId: String, ex) 0 - 전체, 1 - 사랑 등등
    func fetchFlowerKeyword(
        keywordId: String,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<[FlowerKeywordModel], NetworkError>) -> Void
    ) {
        let flowerKeywordAPI = FlowerKeywordAPI(keywordId: keywordId)
        networkService.request(flowerKeywordAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(FlowerKeywordDTO.convertFlowerKeywordDTOToModel(DTO)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postMemberRegister(
        memberRegisterRequestDTO: MemberRegisterRequestDTO,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<MemberRegisterDTO, NetworkError>) -> Void
    ) {
        let memberRegisterAPI = MemberRegisterAPI(requestDTO: memberRegisterRequestDTO)
        networkService.request(memberRegisterAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
