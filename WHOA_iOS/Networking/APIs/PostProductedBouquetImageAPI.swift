//
//  PostProductedBouquetImageAPI.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 10/3/24.
//

import Foundation

struct PostProductedBouquetImageAPI: ServableAPI {
    typealias Response = PostProductedBouquetImageDTO
    
    let memberID: String
    let boundary = UUID().uuidString
    
    let bouquetId: Int
    let imageUrl: [ImageFile]?

    var method: HTTPMethod { .post }
    var path: String { "/api/v2/images/multipart-file/" }
    var params: String { "\(bouquetId)" }
    
    var headers: [String : String]? {
        [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "MEMBER_ID": memberID,
        ]
    }
    
    var multipartData: Data? {
        createMultipartFormData(
            name: "imgFile",
            parameters: [:],
            files: imageUrl,
            boundary: boundary
        )
    }
}
