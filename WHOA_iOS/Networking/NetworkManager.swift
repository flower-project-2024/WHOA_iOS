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
        completion: @escaping (Result<FlowerKeywordDTO, NetworkError>) -> Void
    ) {
        let flowerKeywordAPI = FlowerKeywordAPI(keywordId: keywordId)
        networkService.request(flowerKeywordAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// UUID로 멤버를 등록하는 함수입니다.
    func createMemberRegister(
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
    
    /// 꽃다발 명세서를 POST하는 함수입니다.
    /// - Parameters:
    /// - Headers - memberID: 멤버 아이디
    /// - Body - postCustomBouquetRequestDTO: 명세서 내용
    func createCustomBouquet(
        postCustomBouquetRequestDTO: PostCustomBouquetRequestDTO,
        memberID: String,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<PostCustomBouquetDTO, NetworkError>) -> Void
    ) {
        let postCustomBouquetAPI = PostCustomBouquetAPI(requestDTO: postCustomBouquetRequestDTO, memberID: memberID)
        networkService.request(postCustomBouquetAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 유저가 등록한 주문서 한 건을 상세 조회하는 함수입니다.
    /// - Parameters:
    /// - MemberID: 멤버 아이디
    /// - bouquetId: 주문서 ID
    func fetchBouquetDetail(
        memberID: String,
        bouquetId: Int,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<BouquetDetailDTO, NetworkError>) -> Void
    ) {
        let bouquetDetailAPI = BouquetDetailAPI(memberID: memberID, bouquetId: bouquetId)
        networkService.request(bouquetDetailAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 꽃다발 명세서를 수정(PUT)하는 함수입니다.
    /// - Parameters:
    /// - Headers - memberID: 멤버 아이디
    /// bouquetId: 변경하는 주문서 ID
    /// - Body - postCustomBouquetRequestDTO: 명세서 내용
    func putCustomBouquet(
        postCustomBouquetRequestDTO: PostCustomBouquetRequestDTO,
        memberID: String,
        bouquetId: Int,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<PostCustomBouquetDTO, NetworkError>) -> Void
    ) {
        let api = PutBouquetAPI(requestDTO: postCustomBouquetRequestDTO, memberID: memberID, bouquetId: bouquetId)
        networkService.request(api) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    /// 유저가 등록한 주문서 한 건을 삭제하는 함수입니다.
    /// - Parameters:
    /// - MemberID: 멤버 아이디
    /// - bouquetId: 주문서 ID
    func deleteBouquet(
        memberID: String,
        bouquetId: Int,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<DeleteBouquetDTO, NetworkError>) -> Void
    ) {
        let deleteBouquetAPI = DeleteBouquetAPI(memberID: memberID, bouquetId: bouquetId)
        
        networkService.request(deleteBouquetAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 커스터마이징의 참고 이미지를 다중으로 업로드하는 함수입니다.
    /// - Parameters:
    /// - MemberID: 멤버 아이디
    /// - bouquetId: 주문서 ID
    /// - imageUrl: 참고 이미지들(png데이터)
    func postMultipartFiles(
        memberID: String,
        bouquetId: Int,
        imageFiles: [ImageFile]?,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<MultipartFilesDTO, NetworkError>) -> Void
    ) {
        let api = MultipartFilesAPI(memberID: memberID, bouquetId: bouquetId, imageUrl: imageFiles)
        
        networkService.request(api) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
