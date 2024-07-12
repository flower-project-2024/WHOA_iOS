//
//  BouquetDetailDTO.swift
//  WHOA_iOS
//
//  Created by KSH on 5/27/24.
//

import Foundation

struct BouquetDetailDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: BouquetDetail
}

struct BouquetDetail: Codable {
    let id: Int
    let purpose: String
    let colorType: String
    let colorName: String
    let pointColor: String?
    let substitutionType: String
    let wrappingType: String
    let priceRange: String
    let requirement: String?
    let imgInfoList: [ImgInfoList]
    let flowerInfoList: [FlowerInfoList]
}

struct FlowerInfoList: Codable {
    let flowerImageUrl: String
    let flowerName: String
    let flowerLanguage: String
}

struct ImgInfoList: Codable {
    let bouquetImageId: String
    let bouquetImageUrl: String
}

extension BouquetDetailDTO {
    static func convertBouquetDetailDTOToModel(_ DTO: BouquetDetailDTO, completion: @escaping (CustomizingSummaryModel?) -> Void) {
        var colors = DTO.data.colorName.components(separatedBy: ",")
        
        if let pointColor = DTO.data.pointColor {
            colors.insert(pointColor, at: 0)
        }
        
        let flowers = DTO.data.flowerInfoList.map { Flower(
            id: nil, photo: $0.flowerImageUrl,
            name: $0.flowerName,
            hashTag: $0.flowerLanguage.components(separatedBy: ", ")
        ) }
        
        let dispatchGroup = DispatchGroup()
        var imageFiles: [ImageFile] = []
        
        for imgPath in DTO.data.imgInfoList {
            dispatchGroup.enter()
            urlStringToImageFile(urlString: imgPath.bouquetImageUrl, filename: "RequirementImage") { imageFile in
                if let imageFile = imageFile {
                    imageFiles.append(imageFile)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let model = CustomizingSummaryModel(
                purpose: PurposeType(rawValue: DTO.data.purpose) ?? .affection,
                numberOfColors: NumberOfColorsType(rawValue: DTO.data.colorType) ?? .oneColor,
                colors: colors,
                flowers: flowers,
                alternative: AlternativesType(rawValue: DTO.data.substitutionType) ?? .colorOriented,
                assign: Assign(packagingAssignType: PackagingAssignType(rawValue: DTO.data.wrappingType) ?? .myselfAssign, text: DTO.data.wrappingType),
                priceRange: DTO.data.priceRange,
                requirement: Requirement(text: DTO.data.requirement, imageFiles: imageFiles)
            )
            completion(model)
        }
    }
}


