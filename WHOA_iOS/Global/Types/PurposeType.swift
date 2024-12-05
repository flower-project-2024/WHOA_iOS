//
//  PurposeType.swift
//  WHOA_iOS
//
//  Created by KSH on 2/8/24.
//

import Foundation

/// 꽃 구매 목적을 정리한 Enum입니다.
enum PurposeType: String {
    case affection = "애정표현/고백/기념일"
    case parting = "이별/추모"
    case gratitude = "감사표현"
    case party = "연회/행사/생일"
    case employment = "취업/개업식"
    case promotion = "승진/취임식"
    case friendship = "우정/추억/청춘"
    case none = "목적없음"
    
    var id: Int {
        switch self {
        case .affection: return 1
        case .parting: return 2
        case .gratitude: return 3
        case .party: return 4
        case .employment: return 5
        case .promotion: return 6
        case .friendship: return 7
        case .none: return 8
        }
    }
}
