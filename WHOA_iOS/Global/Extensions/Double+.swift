//
//  Double+.swift
//  WHOA_iOS
//
//  Created by KSH on 11/20/24.
//

import Foundation

extension Double {
    /// 천 단위 반올림한 정수 반환 함수입니다.
    func roundedToThousands() -> Int {
        return Int((self / 1000.0).rounded() * 1000)
    }
}
