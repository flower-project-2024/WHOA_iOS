//
//  PostBouquetAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 5/31/24.
//

import Foundation

struct PostBouquetAPI: ServableAPI {
    typealias Response = MultipartFilesDTO
    
    let memberID: String
    let boundary = UUID().uuidString
    let postCustomBouquetRequestDTO : PostCustomBouquetRequestDTO
    let imageUrl: [ImageFile]?
    
    var method: HTTPMethod { .post }
    var path: String { "/api/v2/bouquet/customizing" }
    var headers: [String : String]? {
        [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "MEMBER_ID": memberID,
        ]
    }
    
    var parameters: [String: Any] {
        [
            "request": postCustomBouquetRequestDTO.createRequestParameterString()
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
