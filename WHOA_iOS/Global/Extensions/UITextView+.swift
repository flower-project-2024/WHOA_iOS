//
//  UITextView+.swift
//  WHOA_iOS
//
//  Created by KSH on 4/30/24.
//

import UIKit
import Combine

extension UITextView {
    var textDidChangePublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: self)
            .compactMap{ ($0.object as? UITextView)?.text ?? "" }
            .eraseToAnyPublisher()
    }
}
