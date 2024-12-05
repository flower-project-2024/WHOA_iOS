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
    
    var textDidBeginEditingPublisher: AnyPublisher<Void, Never> {
        NotificationCenter.default.publisher(for: UITextView.textDidBeginEditingNotification, object: self)
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    var textDidEndEditingPublisher: AnyPublisher<Void, Never> {
        NotificationCenter.default.publisher(for: UITextView.textDidEndEditingNotification, object: self)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}
