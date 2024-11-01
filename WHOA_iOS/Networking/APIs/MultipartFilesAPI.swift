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
            "request": """
            {
                \"bouquetName\": \"\(postCustomBouquetRequestDTO.bouquetName)\",
                \"purpose\": \"\(postCustomBouquetRequestDTO.purpose)\",
                \"colorType\": \"\(postCustomBouquetRequestDTO.colorType)\",
                \"colorName\": \"\(postCustomBouquetRequestDTO.colorName)\",
                \"pointColor\": \"\(postCustomBouquetRequestDTO.pointColor ?? "")\",
                \"flowerType\": \"\(postCustomBouquetRequestDTO.flowerType)\",
                \"substitutionType\" : \"\(postCustomBouquetRequestDTO.substitutionType)\",
                \"wrappingType\": \"\(postCustomBouquetRequestDTO.wrappingType)\",
                \"price\": \"\(postCustomBouquetRequestDTO.price)\",
                \"requirement\": \"\(postCustomBouquetRequestDTO.requirement ?? "")\"
            }
            """
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
