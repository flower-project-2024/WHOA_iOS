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
    case birthday = "생일/생신"
    case gratitude = "감사표현"
    case propose = "프로포즈/결혼식"
    case party = "연회/행사/생일"
    case employment = "취업/개업식"
    case promotion = "승진/취임식"
    case friendship = "우정/추억/청춘"
    case none = "구매 목적 없음"
}
