//
//  Int+.swift
//  WHOA_iOS
//
//  Created by KSH on 5/3/24.
//

import Foundation

extension Int {
    func decimalFormattedString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}

