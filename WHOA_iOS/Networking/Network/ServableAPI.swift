//
//  ServableAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 2/23/24.
//

import Foundation

// 같은 API 제공자에게서 여러개의 API를 요청할 때 도메인 등의 중복 값들을 생략가능
// path, parameter, 도메인 주소까지 커스텀 가능
protocol ServableAPI {
    associatedtype Response: Decodable
    var method: HTTPMethod { get }
    var headers: [String : String]? { get }
    var path: String { get }
    var params: String { get }
}

extension ServableAPI {
    var baseURL: String { "http://3.35.183.117:8080" }
    var urlRequest: URLRequest {
        let urlString = baseURL + path + params
        
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let headers = headers {
            headers.forEach { (key: String, value: String) in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        return request
    }
}
