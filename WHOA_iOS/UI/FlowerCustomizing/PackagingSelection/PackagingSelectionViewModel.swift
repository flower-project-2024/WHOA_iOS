//
//  PackagingSelectionViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 3/9/24.
//

import Foundation
import Combine

final class PackagingSelectionViewModel {
    
    // MARK: - Properties
    
    @Published var packagingSelectionModel = PackagingSelectionModel(packagingAssignButtonType: nil, text: "")
    @Published var isNextButtonActive = false
    
    var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Initialization
    
    init() {
        $packagingSelectionModel
            .map { model -> Bool in
                return model.packagingAssignButtonType == .managerAssign ?
                true : !model.text.isEmpty
            }
            .assign(to: \.isNextButtonActive, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Functions
    
    func updateText(_ text: String) {
        packagingSelectionModel.text = text
    }
    
    func getPackagingAssign(packagingAssign: PackagingAssignType) {
        packagingSelectionModel.packagingAssignButtonType = packagingAssign
    }
}
