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
    /// - Parameters:
    ///   - memberId: 멤버 id
    func fetchAllBouquets(
        memberId: String,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<[BouquetModel], NetworkError>) -> Void
    ) {
        let bouquetAllAPI = BouquetAllAPI(memberId: memberId)
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
        customizingPurposeId: Int,
        keywordId: Int,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<FlowerKeywordDTO, NetworkError>) -> Void
    ) {
        let flowerKeywordAPI = FlowerKeywordAPI(
            customizingPurposeId: customizingPurposeId,
            keywordId: keywordId
        )
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
    
    /// 저렴한 꽃 랭킹을 조회하는 함수입니다.
    func fetchCheapFlowerRanking(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<[CheapFlowerModel], NetworkError>) -> Void
    ){
        let cheapFlowerRankingAPI = CheapFlowerRankingAPI()
        networkService.request(cheapFlowerRankingAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(CheapFlowerRankingDTO.convertCheapFlowerRankingDTOToModel(DTO: DTO)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 커스터마이징의 참고 이미지를 다중으로 업로드하는 함수입니다.
    /// - Parameters:
    /// - memberID: 멤버 아이디
    /// - postCustomBouquetRequestDTO: 명세서 내용
    /// - imageUrl: 참고 이미지들(png데이터)
    func createCustomBouquet(
        memberID: String,
        postCustomBouquetRequestDTO: PostCustomBouquetRequestDTO,
        imageFiles: [ImageFile]?,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<MultipartFilesDTO, NetworkError>) -> Void
    ) {
        let api = PostBouquetAPI(
            memberID: memberID,
            postCustomBouquetRequestDTO: postCustomBouquetRequestDTO,
            imageUrl: imageFiles
        )
        networkService.request(api) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 오늘의 꽃을 조회하는 함수입니다
    func fetchTodaysFlower(
        month: String,
        date: String,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<TodaysFlowerModel, NetworkError>) -> Void
    ){
        let todaysFlowerAPI = TodaysFlowerAPI(date: date, month: month)
        networkService.request(todaysFlowerAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(TodaysFlowerDTO.convertTodaysFlowerDTOToModel(DTO: DTO)))
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
    
    /// 꽃 검색을 위한 꽃 정보를 조회하는 함수입니다.
    func fetchFlowersForSearch(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<[FlowerSearchModel], NetworkError>) -> Void
    ){
        let flowerSearchAPI = FlowerSearchAPI()
        networkService.request(flowerSearchAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(FlowerSearchDTO.convertFlowerSearchDTOToModel(DTO: DTO)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// 꽃다발 명세서를 수정(PUT)하는 함수입니다.
    /// - Parameters:
    /// - Headers - memberID: 멤버 아이디
    /// - bouquetId: 변경하는 주문서 ID
    /// - Body - postCustomBouquetRequestDTO: 명세서 내용
    func putCustomBouquet(
        bouquetId: Int,
        memberID: String,
        postCustomBouquetRequestDTO: PostCustomBouquetRequestDTO,
        imageFiles: [ImageFile]?,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<PostCustomBouquetDTO, NetworkError>) -> Void
    ) {
        let api = PutBouquetAPI(bouquetId: bouquetId, memberID: memberID, requestDTO: postCustomBouquetRequestDTO, imageUrl: imageFiles)
        networkService.request(api) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 꽃 상세 정보를 조회하는 함수입니다.
    func fetchFlowerDetail(
        flowerId: Int,
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<FlowerDetailModel, NetworkError>) -> Void
    ){
        let flowerDetailAPI = FlowerDetailAPI(flowerId: flowerId)
        networkService.request(flowerDetailAPI) { result in
            switch result {
            case .success(let DTO):
                completion(.success(FlowerDetailDTO.convertFlowerDetailDTOToModel(DTO: DTO)))
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
    
    /// 꽃다발의 status를 제작 완료로 처리하는 함수입니다.
    /// - Parameters:
    /// - memberId: 멤버 id
    /// - bouquetId: 꽃다발 요구서 id
    func patchBouquetStatus(memberId: String,
                            bouquetId: Int,
                            _ networkService: NetworkServable = NetworkService(),
                            completion: @escaping (Result<BouquetStatusDTO, NetworkError>) -> Void
    ) {
        let api = PatchBouquetStatusAPI(memberID: memberId, bouquetId: bouquetId)
        
        networkService.request(api) { result in
            switch result {
            case .success(let DTO):
                completion(.success(DTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 꽃다발을 제작 완료 처리한 후 실제 제작한 꽃다발 사진을 업로드하는 함수입니다.
    /// - Parameters:
    ///   - memberID: 멤버 id
    ///   - bouquetId: 꽃다발 요구서 id
    ///   - imageFile: 등록하려는 이미지 imageFile
    func postProductedBouquetImage(memberID: String,
                            bouquetId: Int,
                            imageFile: [ImageFile]?,
                            _ networkService: NetworkServable = NetworkService(),
                            completion: @escaping (Result<PostProductedBouquetImageDTO, NetworkError>) -> Void
    ) {
        let api = PostProductedBouquetImageAPI(memberID: memberID, bouquetId: bouquetId, imageUrl: imageFile)
        
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
