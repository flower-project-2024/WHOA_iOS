//
//  NumberOfColorsType.swift
//  WHOA_iOS
//
//  Created by KSH on 2/21/24.
//

import Foundation

/// 색상 개수를 정리한 Enum입니다.
enum NumberOfColorsType: String {
    case oneColor = "단일 색"
    case twoColor = "두 가지 색"
    case colorful = "컬러풀"
    case pointColor = "포인트 컬러"
    case none
    
    func toDTOString() -> String {
            switch self {
            case .oneColor:
                return "ONE_COLOR"
            case .twoColor:
                return "TWO_COLORS"
            case .colorful:
                return "COLORFULL"
            case .pointColor:
                return "POINT_COLOR"
            case .none:
                return "none"
            }
        }
}
