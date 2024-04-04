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
    var path: String { get }
    var params: [String: String] { get }
}

extension ServableAPI {
    var baseURL: String { "http://ec2-3-35-183-117.ap-northeast-2.compute.amazonaws.com" }
    var method: HTTPMethod { .get }
    var headers: [String : String]? { nil }
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: baseURL + path)!
        let queryItems = params.map { (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        }
        urlComponents.queryItems = queryItems

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue

        if let headers {
            headers.forEach { (key: String, value: String) in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }

        return request
    }
}
