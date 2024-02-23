//
//  NetworkManager.swift
//  WHOA_iOS
//
//  Created by KSH on 2/23/24.
//

import Foundation

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
}
