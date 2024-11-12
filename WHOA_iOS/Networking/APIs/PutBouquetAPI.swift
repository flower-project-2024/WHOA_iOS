//
//  PutBouquetAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 7/3/24.
//

import Foundation

struct PutBouquetAPI: ServableAPI {
    typealias Response = PostCustomBouquetDTO
    
    let bouquetId: Int
    let memberID: String
    let boundary = UUID().uuidString
    let requestDTO: PostCustomBouquetRequestDTO
    let imageUrl: [ImageFile]?
    
    var method: HTTPMethod { .put }
    var path: String { "/api/v2/bouquet/customizing/" }
    var params: String { "\(bouquetId)" }
    var headers: [String: String]? {
        [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "MEMBER_ID": memberID
        ]
    }
    
    var parameters: [String: Any] {
        [
            "request": requestDTO.createRequestParameterString()
        ]
    }
    
    var multipartData: Data? {
        createMultipartFormData(
            name: "imgUrl",
            parameters: parameters,
            files: imageUrl,
            boundary: boundary
        )
    }
}
