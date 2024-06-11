//
//  MultipartFilesAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 5/31/24.
//

import Foundation

struct MultipartFilesAPI: ServableAPI {
    typealias Response = MultipartFilesDTO
    
    let boundary = UUID().uuidString
    let imageFile: [ImageFile]?
    let category: String
    let name: String
    
    var parameters: [String: String] {
        [
            "category": category,
            "name": name
        ]
    }
    
    var method: HTTPMethod { .post }
    var path: String { "" }
    var headers: [String : String]? {
        [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
        ]
    }
    var multipartData: Data? {
        createMultipartFormData(
            parameters: parameters,
            file: imageFile,
            boundary: boundary
        )
    }
}
