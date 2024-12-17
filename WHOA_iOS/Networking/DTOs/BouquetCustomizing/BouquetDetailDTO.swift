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
    let bouquetStatus: String
    let selectedFlowersInfoList: [FlowerInfoList]
    let uploadedBouquetCustomizingImagesInfoList: [ImgInfoList]
    let bouquetRealImage: String?
}

struct FlowerInfoList: Codable {
    let flowerKeywords: String  // "아름다운, 존경"
    let flowerImageUrl: String
    let flowerName: String
    let flowerLanguage: String  // "화사한 매력, 명성"
    let id: String
}

struct ImgInfoList: Codable {
    let bouquetImageId: String
    let bouquetImageUrl: String
}

extension BouquetDetailDTO {
    /// BouquetDetail을 RequestDetailModel로 변환합니다.
    static func convertToRequestDetailModel(_ dto: BouquetDetailDTO) -> RequestDetailModel? {
        let detail = dto.data
        let bouquetData = convertToBouquetData(requestTitle: "", detail: detail)
        let status = BouquetStatusType(rawValue: detail.bouquetStatus) ?? .saved
        
        return RequestDetailModel(
            bouquetData: bouquetData,
            status: status,
            bouquetRealImage: detail.bouquetRealImage
        )
    }
    
    /// BouquetDetailDTO를 BouquetData로 변환하고 저장합니다.
    static func saveBouquetData(
        requestTitle: String,
        dto: BouquetDetailDTO,
        dataManager: BouquetDataManaging
    ) {
        let detail = dto.data
        let bouquetData = convertToBouquetData(requestTitle: requestTitle, detail: detail)
        dataManager.setBouquet(bouquetData)
    }
    
    // MARK: - Functions
    
    private static func convertToBouquetData(requestTitle: String, detail: BouquetDetail) -> BouquetData {
        return BouquetData(
            requestTitle: requestTitle,
            purpose: PurposeType(rawValue: detail.purpose) ?? .none,
            colorScheme: convertToColorScheme(from: detail),
            flowers: convertToFlowers(from: detail.selectedFlowersInfoList),
            alternative: AlternativesType(rawValue: detail.substitutionType) ?? .none,
            packagingAssign: convertToPackagingAssign(from: detail),
            price: convertToPrice(from: detail.priceRange),
            requirement: convertToRequirement(from: detail)
        )
    }
    
    private static func convertToColorScheme(from detail: BouquetDetail) -> BouquetData.ColorScheme {
        return BouquetData.ColorScheme(
            numberOfColors: NumberOfColorsType(rawValue: detail.colorType) ?? .none,
            pointColor: detail.pointColor,
            colors: detail.colorName.components(separatedBy: ", ")
        )
    }
    
    private static func convertToFlowers(from list: [FlowerInfoList]) -> [BouquetData.Flower] {
        return list.map {
            BouquetData.Flower(
                id: Int($0.id),
                photo: $0.flowerImageUrl,
                name: $0.flowerName,
                hashTag: $0.flowerLanguage.components(separatedBy: ", "),
                flowerKeyword: $0.flowerKeywords.components(separatedBy: ", ")
            )
        }
    }
    
    private static func convertToPackagingAssign(from detail: BouquetDetail) -> BouquetData.PackagingAssign {
        return BouquetData.PackagingAssign(
            assign: PackagingAssignType(rawValue: detail.wrappingType) ?? .myselfAssign,
            text: detail.wrappingType
        )
    }
    
    private static func convertToPrice(from priceRange: String) -> BouquetData.Price {
        let priceSplit = priceRange.components(separatedBy: " ~ ")
        guard priceSplit.count == 2,
              let minPrice = Int(priceSplit[0].replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)),
              let maxPrice = Int(priceSplit[1].replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)) else {
            print("Error: Failed to convert price range, using default values")
            return BouquetData.Price(min: 0, max: 100000)
        }
        return BouquetData.Price(min: minPrice, max: maxPrice)
    }
    
    private static func convertToRequirement(from detail: BouquetDetail) -> BouquetData.Requirement {
        let images = detail.uploadedBouquetCustomizingImagesInfoList
            .compactMap { URL(string: $0.bouquetImageUrl) }
            .compactMap { try? Data(contentsOf: $0) }
        
        return BouquetData.Requirement(
            text: detail.requirement,
            images: images
        )
    }
}


