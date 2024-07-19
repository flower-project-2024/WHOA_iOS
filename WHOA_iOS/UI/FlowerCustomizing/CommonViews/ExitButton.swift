//
//  ExitButton.swift
//  WHOA_iOS
//
//  Created by KSH on 2/9/24.
//

import UIKit

final class ExitButton: UIImageView {
    
    // MARK: - Properties
    
    let currentVC: UIViewController
    let coordinator: CustomizingCoordinator?
    
    // MARK: - Initialize
    
    init(currentVC: UIViewController, coordinator: CustomizingCoordinator?) {
        self.currentVC = currentVC
        self.coordinator = coordinator
        super.init(frame: .zero)
        
        setupView()
        addTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupView() {
        self.image = UIImage(named: "Xmark")
        self.tintColor = .black
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = true
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func handleTap() {
        coordinator?.showExitAlertVC(from: currentVC)
    }
}
