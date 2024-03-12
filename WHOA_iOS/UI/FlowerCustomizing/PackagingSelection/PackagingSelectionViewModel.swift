//
//  PackagingSelectionViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 3/9/24.
//

import Foundation

class PackagingSelectionViewModel {
    
    // MARK: - Properties
    
    var savedText: String = "" {
        didSet {
            savedTextDidChanged?(savedText)
        }
    }
    
    var savedTextDidChanged: ((_ savedText: String) -> Void)?
}
