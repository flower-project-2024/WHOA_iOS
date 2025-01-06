//
//  HomeVC.swift
//  WHOA_iOS
//
//  Created by KSH on 12/12/24.
//

import UIKit

final class HomeVC: UIViewController {
    
    // MARK: - Properties
    
    private let rootView: HomeMainView
    
    // MARK: - Initialize
    
    init() {
        self.rootView = HomeMainView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: - Functions
    
    private func setupNavigationBar() {
        let imageView = UIImageView(image: .whoaLogo)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
}

