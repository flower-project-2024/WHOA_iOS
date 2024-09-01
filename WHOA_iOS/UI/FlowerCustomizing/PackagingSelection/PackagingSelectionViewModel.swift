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
    
    let dataManager: BouquetDataManaging
    @Published var packagingSelectionModel = PackagingSelectionModel(packagingAssignButtonType: nil, text: "")
    @Published var isNextButtonActive = false
    var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = DataManager.shared) {
        self.dataManager = dataManager
        
        $packagingSelectionModel
            .map { model -> Bool in
                guard model.packagingAssignButtonType != .none else { return false }
                return model.packagingAssignButtonType == .managerAssign ? true : !model.text.isEmpty
            }
            .assign(to: \.isNextButtonActive, on: self)
            .store(in: &cancellables)
        configData(dataManager.getPackagingAssign())
    }
    
    // MARK: - Functions
    
    private func configData(_ assign: BouquetData.PackagingAssign) {
        getPackagingAssign(packagingAssign: assign.assign)
        if let text = assign.text, !text.isEmpty {
            updateText(text)
        }
    }
    
    func updateText(_ text: String) {
        packagingSelectionModel.text = text
    }
    
    func getPackagingAssign(packagingAssign: PackagingAssignType) {
        packagingSelectionModel.packagingAssignButtonType = packagingAssign
    }
}
