//
//  AlternativeType.swift
//  WHOA_iOS
//
//  Created by KSH on 4/26/24.
//

import Foundation

/// 대체 타입을 정리한 Enum입니다.
enum AlternativesType: String {
    case colorOriented = "색감 위주"
    case hashTagOriented = "꽃말 위주"
    case none
    
    func toDTOString() -> String {
        switch self {
        case .colorOriented:
            return "FOCUS_ON_COLOR"
        case .hashTagOriented:
            return "FOCUS_ON_FLOWER_LANGUAGE"
        case .none:
            return "none"
        }
    }
}
