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
    
    /// 앨범들을 조회하는 함수입니다.
    func fetchNetworkingTest(
        _ networkService: NetworkServable = NetworkService(),
        completion: @escaping (Result<TestDTO, NetworkError>) -> Void
    ) {
        let testAPI = TestAPI()
        networkService.request(testAPI) { result in
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
    
    /// 오늘의 꽃을 조회하는 함수입니다
    func fetchTodaysFlower(
        month: Int,
        date: Int,
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
}
