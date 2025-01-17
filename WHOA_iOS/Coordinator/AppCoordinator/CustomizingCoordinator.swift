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
    
    
    // MARK: - Initialize
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    
    func start() {
        let customStartVC = CustomStartViewController()
        customStartVC.coordinator = self
        navigationController.pushViewController(customStartVC, animated: true)
    }
    
    func showPurposeVC() {
        let viewModel = PurposeViewModel()
        let purposeVC = PurposeViewController(viewModel: viewModel)
        purposeVC.coordinator = self
        navigationController.pushViewController(purposeVC, animated: true)
    }
    
    func showColorPickerVC() {
        let viewModel = FlowerColorPickerViewModel()
        let flowerColorPickerVC = FlowerColorPickerViewController(viewModel: viewModel)
        flowerColorPickerVC.coordinator = self
        navigationController.pushViewController(flowerColorPickerVC, animated: true)
    }
    
    func showFlowerSelectionVC() {
        let viewModel = FlowerSelectionViewModel()
        let flowerSelectionVC = FlowerSelectionViewController(viewModel: viewModel)
        flowerSelectionVC.coordinator = self
        navigationController.pushViewController(flowerSelectionVC, animated: true)
    }
    
    func showAlternativesVC(from currentVC: UIViewController?) {
        let viewModel = AlternativesViewModel()
        let alternativesVC = AlternativesViewController(viewModel: viewModel)
        alternativesVC.coordinator = self
        
        if let sheet = alternativesVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24.0
        }
        
        currentVC?.present(alternativesVC, animated: true)
    }
    
    func showPackagingSelectionVC(from currentVC: UIViewController?) {
        let viewModel = PackagingSelectionViewModel()
        let packagingSelectionVC = PackagingSelectionViewController(viewModel: viewModel)
        packagingSelectionVC.coordinator = self
        
        currentVC?.dismiss(animated: true) { [weak self] in
            self?.navigationController.pushViewController(packagingSelectionVC, animated: true)
        }
    }
    
    func showFlowerPriceVC() {
        let viewModel = FlowerPriceViewModel()
        let FlowerPriceVC = FlowerPriceViewController(viewModel: viewModel)
        FlowerPriceVC.coordinator = self
        navigationController.pushViewController(FlowerPriceVC, animated: true)
    }
    
    func showPhotoSelectionVC() {
        let viewModel = PhotoSelectionViewModel()
        let photoSelectionVC = PhotoSelectionViewController(viewModel: viewModel)
        photoSelectionVC.coordinator = self
        navigationController.pushViewController(photoSelectionVC, animated: true)
    }
    
    func showCustomizingSummaryVC() {
        let viewModel = CustomizingSummaryViewModel()
        let customizingSummaryVC = CustomizingSummaryViewController(viewModel: viewModel)
        customizingSummaryVC.coordinator = self
        navigationController.pushViewController(customizingSummaryVC, animated: true)
    }
}

extension CustomizingCoordinator {
    func showExitAlertVC(from currentVC: UIViewController?) {
        guard currentVC?.presentedViewController == nil else { return }
        let customExitAlertVC = CustomExitAlertViewController(currentVC: currentVC)
        customExitAlertVC.modalPresentationStyle = .overFullScreen
        currentVC?.present(customExitAlertVC, animated: false)
    }
    
    func showSaveAlert(from currentVC: UIViewController, saveResult: SaveResult) {
        let saveAlertVC = SaveAlertViewController(currentVC: currentVC, saveResult: saveResult)
        saveAlertVC.modalPresentationStyle = .overFullScreen
        currentVC.present(saveAlertVC, animated: false)
    }
    
    func showPhotoPicker(
        from currentVC: UIViewController?,
        photosCount: Int,
        photoSelectionLimitCount: Int,
        completion: @escaping ([Int: UIImage?]) -> Void
    ) {
        
        let photoPickerVC = PhotoViewController(
            photosCount: photosCount,
            photoSelectionLimitCount: photoSelectionLimitCount
        )
        photoPickerVC.modalPresentationStyle = .fullScreen
        currentVC?.present(photoPickerVC, animated: true)
        
        photoPickerVC.completionHandler = { selectedImages in
            completion(selectedImages)
        }
    }
}
