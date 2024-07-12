//
//  CustomTableView.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 6/29/24.
//

import UIKit

class CustomTableView: UITableView {

  override var intrinsicContentSize: CGSize {
    return self.contentSize
  }

  override var contentSize: CGSize {
    didSet {
        self.invalidateIntrinsicContentSize()
    }
  }
}
