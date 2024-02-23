//
//  ServableAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 2/23/24.
//

import Foundation

protocol ServableAPI {
    associatedtype Response: Decodable
    var path: String { get }
    var params: [String: String] { get }
}

extension ServableAPI {
    // 테스트용 baseURL입니다.
    var baseURL: String { "https://itunes.apple.com/search" }
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
