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
    var params: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String]? { get }
    var requestBody: Encodable? { get }
    var multipartData: Data? { get }
}

extension ServableAPI {
    var baseURL: String { "http://3.35.183.117:8080" }
    var params: String { "" }
    var method: HTTPMethod { .get }
    var headers: [String : String]? { nil }
    var requestBody: Encodable? { nil }
    var multipartData: Data? { nil }
    
    var urlRequest: URLRequest {
        let urlString = baseURL + path + params
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            headers.forEach { (key: String, value: String) in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let requestBody = requestBody, let jsonData = try? JSONEncoder().encode(requestBody) {
            request.httpBody = jsonData
        }
        
        if let multipartData = multipartData {
            request.httpBody = multipartData
        }
        
        return request
    }
    
    func createMultipartFormData(name: String, parameters: [String: Any], files: [ImageFile]?, boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        if let files = files {
            for file in files {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(name)\";  filename=\"\(file.filename).png\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: \(file.type)\r\n\r\n".data(using: .utf8)!)
                body.append(file.data)
                body.append("\r\n".data(using: .utf8)!)
            }
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        }
        
        return body
    }
}
