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
            "request": createRequestParameterString()
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

extension PostBouquetAPI {
    func createRequestParameterString() -> String {
        var requestParameters: [String: Any] = [
            "bouquetName": postCustomBouquetRequestDTO.bouquetName,
            "purpose": postCustomBouquetRequestDTO.purpose,
            "colorType": postCustomBouquetRequestDTO.colorType,
            "colorName": postCustomBouquetRequestDTO.colorName,
            "flowerType": postCustomBouquetRequestDTO.flowerType,
            "substitutionType": postCustomBouquetRequestDTO.substitutionType,
            "wrappingType": postCustomBouquetRequestDTO.wrappingType,
            "price": postCustomBouquetRequestDTO.price
        ]

        if let pointColor = postCustomBouquetRequestDTO.pointColor {
            requestParameters["pointColor"] = pointColor
        }
        if let requirement = postCustomBouquetRequestDTO.requirement {
            requestParameters["requirement"] = requirement
        }

        if let jsonData = try? JSONSerialization.data(withJSONObject: requestParameters, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString.replacingOccurrences(of: "\\/", with: "/")
        } else {
            return "{}"
        }
    }
}
