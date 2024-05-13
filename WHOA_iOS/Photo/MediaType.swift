//
//  MediaType.swift
//  WHOA_iOS
//
//  Created by KSH on 3/13/24.
//

import Foundation

enum MediaType {
    case all
    case image
    case video
    
    var title: String {
        switch self {
        case .all:
            return "이미지와 비디오"
        case .image:
            return "이미지"
        case .video:
            return "비디오"
        }
    }
}
