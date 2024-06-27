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
    
    let bouquetId: Int
    let imageUrl: [ImageFile]?
    
    var method: HTTPMethod { .post }
    var path: String { "/api/images/multipart-files" }
    var headers: [String : String]? {
        [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "MEMBER_ID": memberID,
        ]
    }
    
    var parameters: [String: Any] {
        [
            "bouquetId": "{\n\"bouquet_id\" : \(bouquetId)\n}",
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
