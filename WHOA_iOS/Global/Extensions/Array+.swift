//
//  Array+.swift
//  WHOA_iOS
//
//  Created by KSH on 12/16/24.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
