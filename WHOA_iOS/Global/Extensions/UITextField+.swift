//
//  UITextField+.swift
//  WHOA_iOS
//
//  Created by KSH on 8/17/24.
//

import UIKit
import Combine

extension UITextField {
    var publisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap{ ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }
}
