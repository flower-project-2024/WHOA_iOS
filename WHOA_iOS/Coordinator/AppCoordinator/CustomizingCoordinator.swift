//
//  CustomizingCoordinator.swift
//  WHOA_iOS
//
//  Created by KSH on 5/28/24.
//

import UIKit

class CustomizingCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    private var purpose: PurposeType = .birthday
    private var colors: [String] = []
    private var flowers: [FlowerKeywordModel] = []
    private var alternative: AlternativesType = .colorOriented
    private var packagingSelectionModel: PackagingSelectionModel?
    private var price: String?
    
    // MARK: - Initialize
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    
    func start() {
        showPurposeVC()
    }
    
    private func showPurposeVC() {
        let viewModel = PurposeViewModel()
        let purposeVC = PurposeViewController(viewModel: viewModel)
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
    
    func showFlowerSelectionVC(colors: [String]) {
        self.colors = colors
        
        let viewModel = FlowerSelectionViewModel(purposeType: purpose)
        let flowerSelectionVC = FlowerSelectionViewController(viewModel: viewModel)
        flowerSelectionVC.coordinator = self
        navigationController.pushViewController(flowerSelectionVC, animated: true)
    }
    
    func showAlternativesVC(from currentVC: UIViewController, flowerKeywordModels: [FlowerKeywordModel]) {
        self.flowers = flowerKeywordModels
        
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
    
    func showFlowerPriceVC(packagingSelectionModel: PackagingSelectionModel?) {
        self.packagingSelectionModel = packagingSelectionModel
        
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
    
    // 최종 데이터 전달 코드 추가
    // 파라미터로 요구사항text, 이미지 추가 필요
    func showCustomizingSummaryVC() {
        let viewModel = CustomizingSummaryViewModel()
        let customizingSummaryVC = CustomizingSummaryViewController(viewModel: viewModel)
        customizingSummaryVC.coordinator = self
        navigationController.pushViewController(customizingSummaryVC, animated: true)
    }
}
