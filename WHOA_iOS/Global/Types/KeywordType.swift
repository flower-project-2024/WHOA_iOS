//
//  KeywordType.swift
//  WHOA_iOS
//
//  Created by KSH on 6/17/24.
//

import Foundation

enum KeywordType: String, CaseIterable {
    case all = "전체"
    case love = "사랑"
    case gratitude = "감사"
    case beauty = "아름다움"
    case friendship = "우정"
    case encouragement = "응원"
    case respect = "존경"
    case remembrance = "추모"
    case joy = "기쁨"
    case happiness = "행복"
    case farewell = "이별"
    case waiting = "기다림"
    case others = "기타"
    
    var keywordId: Int {
        switch self {
        case .all:
            return 0
        case .love:
            return 1
        case .gratitude:
            return 2
        case .beauty:
            return 3
        case .friendship:
            return 4
        case .encouragement:
            return 5
        case .respect:
            return 6
        case .remembrance:
            return 7
        case .joy:
            return 8
        case .happiness:
            return 9
        case .farewell:
            return 10
        case .waiting:
            return 11
        case .others:
            return 12
        }
    }
}
