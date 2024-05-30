//
//  ExitButton.swift
//  WHOA_iOS
//
//  Created by KSH on 2/9/24.
//

import UIKit

class ExitButton: UIImageView {
    
    // MARK: - Initialization
    
    init() {
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
        showExitAlert()
    }
    
    private func showExitAlert() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let topViewController = windowScene.windows.first?.rootViewController else { return }
        let customAlertVC = CustomExitAlertViewController()
        
        customAlertVC.modalPresentationStyle = .overFullScreen
        topViewController.present(customAlertVC, animated: false, completion: nil)
        
    }
}
