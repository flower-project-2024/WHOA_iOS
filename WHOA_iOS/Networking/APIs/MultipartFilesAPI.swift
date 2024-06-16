//
//  MultipartFilesAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 5/31/24.
//

import Foundation

struct MultipartFilesAPI: ServableAPI {
    typealias Response = MultipartFilesDTO
    
    let memberID: String
    let boundary = UUID().uuidString
    
    let bouquetId: String
    let imageUrl: [ImageFile]?
    
    var method: HTTPMethod { .post }
    var path: String { "/api/images/multipart-files/" }
    var headers: [String : String]? {
        [
            "MEMBER_ID": memberID,
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
        ]
    }
    
    var parameters: [String: String] {
        [
            "bouquetId": bouquetId,
        ]
    }
    
    var multipartData: Data? {
        createMultipartFormData(
            parameters: parameters,
            files: imageUrl,
            boundary: boundary
        )
    }
}
