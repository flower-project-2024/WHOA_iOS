//
//  FlowerColorPickerViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import UIKit

class FlowerColorPickerViewController: UIViewController {

    // MARK: - Properties

    let viewModel: FlowerColorPickerViewModel
    
    
    // MARK: - Initialize
    init(viewModel: FlowerColorPickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
        print(viewModel.intentType)
    }
}
