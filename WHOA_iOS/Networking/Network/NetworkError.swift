//
//  NetworkError.swift
//  WHOA_iOS
//
//  Created by KSH on 2/23/24.
//

import Foundation

enum NetworkError: Error {
    /** 네트워크에 연결되어 있지 않을 때 에러*/ case disconnected
    /** API에 문제가 있을 때 에러*/ case apiIssue
    /** 클라이언트 에러*/ case clientError
    /** 404전용 데이터 없을 시 에러*/ case notFound
    /** 409전용 데이터 충돌 시 에러*/ case duplicateError
    /** 서버 에러*/ case serverError
    /** response에 데이터가 없을 때 에러*/ case noData
    /** 디코딩 실패  에러*/ case unableToDecode
    /** 알 수 없는 에러*/ case unknownError
}

extension NetworkError {
    var localizedDescription: String {
        switch self {
        case .disconnected: return "네트워크에 연결되어 있지 않습니다."
        case .apiIssue: return "요청 API에 문제가 있습니다."
        case .clientError: return "클라이언트에 문제가 있습니다."
        case .notFound: return "요청한 리소스를 찾을 수 없습니다."
        case .duplicateError: return "데이터 충돌이 있습니다."
        case .serverError: return "서버에 문제가 있습니다."
        case .noData: return "데이터가 없습니다."
        case .unableToDecode: return "디코딩에 실패했습니다."
        case .unknownError: return "알 수 없는 오류입니다."
        }
    }
}
