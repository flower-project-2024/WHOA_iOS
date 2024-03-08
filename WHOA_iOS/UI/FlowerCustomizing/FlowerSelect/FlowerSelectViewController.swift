//
//  FlowerSelectViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/23/24.
//

import UIKit

class FlowerSelectViewController: UIViewController {

    // MARK: - Lifecycle
    var tempModel: FlowerColorPickerModel
    
    init(tempModel: FlowerColorPickerModel) {
        self.tempModel = tempModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(tempModel)
        view.backgroundColor = .red
    }

}
