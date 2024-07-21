//
//  UIViewController+.swift
//  WHOA_iOS
//
//  Created by KSH on 4/3/24.
//

import UIKit

extension UIViewController {
    func showToast(message: String, font: UIFont) {
        let toastLabelWidth = self.view.frame.size.width / 1.5
        let toastLabel = UILabel(frame: CGRect(
            x: self.view.frame.size.width / 2 - (toastLabelWidth / 2),
            y: self.view.frame.size.height - 100,
            width: toastLabelWidth,
            height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showAlert(title: String = "", message: String = "", alertActions: [UIAlertAction] = []) {
        let sheet = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        if alertActions.isEmpty {
            let confirmAction = UIAlertAction(title: "확인", style: .default)
            sheet.addAction(confirmAction)
        } else {
            alertActions.forEach { alertAction in
                sheet.addAction(alertAction)
            }
        }
        
        DispatchQueue.main.async {
            self.present(sheet, animated: true)
        }
    }
}
