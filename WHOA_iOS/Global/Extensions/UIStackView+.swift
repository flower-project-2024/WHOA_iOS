//
//  UIStackView+.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 7/3/24.
//

import UIKit

/// 스택뷰의 모든 자식 뷰를 삭제하는 함수입니다.
extension UIStackView {
    func removeArrangedSubviews() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}
