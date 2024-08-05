//
//  CustomizingCoordinator.swift
//  WHOA_iOS
//
//  Created by KSH on 5/28/24.
//

import UIKit

final class CustomizingCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    private var purpose: PurposeType = .none
    private var numberOfColors: NumberOfColorsType = .oneColor
    private var colors: [String] = []
    private var flowers: [Flower] = []
    private var alternative: AlternativesType = .colorOriented
    private var packagingAssign: PackagingAssignType = .managerAssign
    private var packagingRequirement: String?
    private var price: String?
    private var requirementPhotos: [ImageFile] = []
    private var requirementText: String?
    
    private var actionType: ActionType = .create
    
    
    // MARK: - Initialize
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    
    func start() {
        showPurposeVC()
    }
    
    func setActionType(actionType: ActionType) {
        self.actionType = actionType
    }
    
    private func showPurposeVC() {
        let viewModel = PurposeViewModel()
        let purposeVC = PurposeViewController(viewModel: viewModel)
        viewModel.purposeModel? = PurposeModel(purposeType: self.purpose)
        purposeVC.coordinator = self
        navigationController.pushViewController(purposeVC, animated: true)
    }
    
    func showColorPickerVC(purposeType: PurposeType) {
        self.purpose = purposeType
        
        let viewModel = FlowerColorPickerViewModel()
        let flowerColorPickerVC = FlowerColorPickerViewController(viewModel: viewModel)
        flowerColorPickerVC.coordinator = self
        navigationController.pushViewController(flowerColorPickerVC, animated: true)
    }
    
    func showFlowerSelectionVC(numberOfColors: NumberOfColorsType, colors: [String]) {
        self.numberOfColors = numberOfColors
        self.colors = colors
        
        let viewModel = FlowerSelectionViewModel(purposeType: purpose)
        let flowerSelectionVC = FlowerSelectionViewController(viewModel: viewModel)
        flowerSelectionVC.coordinator = self
        navigationController.pushViewController(flowerSelectionVC, animated: true)
    }
    
    func showAlternativesVC(from currentVC: UIViewController, flowers: [Flower]) {
        self.flowers = flowers
        
        let viewModel = AlternativesViewModel()
        let alternativesVC = AlternativesViewController(viewModel: viewModel)
        alternativesVC.coordinator = self
        
        if let sheet = alternativesVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24.0
        }
        
        currentVC.present(alternativesVC, animated: true)
    }
    
    func showPackagingSelectionVC(from currentVC: UIViewController, alternative: AlternativesType) {
        self.alternative = alternative
        
        let viewModel = PackagingSelectionViewModel()
        let packagingSelectionVC = PackagingSelectionViewController(viewModel: viewModel)
        packagingSelectionVC.coordinator = self
        
        currentVC.dismiss(animated: true) { [weak self] in
            self?.navigationController.pushViewController(packagingSelectionVC, animated: true)
        }
    }
    
    func showFlowerPriceVC(packagingAssign: PackagingAssignType, packagingRequirement: String?) {
        self.packagingAssign = packagingAssign
        self.packagingRequirement = packagingRequirement
        
        let viewModel = FlowerPriceViewModel()
        let FlowerPriceVC = FlowerPriceViewController(viewModel: viewModel)
        FlowerPriceVC.coordinator = self
        navigationController.pushViewController(FlowerPriceVC, animated: true)
    }
    
    func showPhotoSelectionVC(price: String) {
        self.price = price
        let viewModel = PhotoSelectionViewModel()
        let photoSelectionVC = PhotoSelectionViewController(viewModel: viewModel)
        photoSelectionVC.coordinator = self
        navigationController.pushViewController(photoSelectionVC, animated: true)
    }
    
    func showCustomizingSummaryVC(requirementPhotos: [ImageFile], requirementText: String?) {
        self.requirementPhotos = requirementPhotos
        self.requirementText = requirementText
        
        let model = CustomizingSummaryModel(
            purpose: self.purpose,
            numberOfColors: self.numberOfColors,
            colors: self.colors,
            flowers: flowers,
            alternative: alternative,
            assign: Assign(packagingAssignType: packagingAssign, text: packagingRequirement),
            priceRange: price ?? "",
            requirement: Requirement(text: requirementText, imageFiles: requirementPhotos)
        )
        
        let viewModel = CustomizingSummaryViewModel(customizingSummaryModel: model, actionType: self.actionType)
        let customizingSummaryVC = CustomizingSummaryViewController(viewModel: viewModel)
        customizingSummaryVC.coordinator = self
        navigationController.pushViewController(customizingSummaryVC, animated: true)
    }
}

extension CustomizingCoordinator {
    func showExitAlertVC(from currentVC: UIViewController?) {
        let customExitAlertVC = CustomExitAlertViewController(currentVC: currentVC)
        customExitAlertVC.modalPresentationStyle = .overFullScreen
        currentVC?.present(customExitAlertVC, animated: false)
    }
    
    func showSaveAlert(from currentVC: UIViewController, saveResult: SaveResult) {
        let saveAlertVC = SaveAlertViewController(currentVC: currentVC, saveResult: saveResult)
        saveAlertVC.modalPresentationStyle = .overFullScreen
        currentVC.present(saveAlertVC, animated: false)
    }
}
