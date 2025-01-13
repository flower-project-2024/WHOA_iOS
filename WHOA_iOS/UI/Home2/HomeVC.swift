//
//  HomeVC.swift
//  WHOA_iOS
//
//  Created by KSH on 12/12/24.
//

import UIKit
import Combine

final class HomeVC: UIViewController {
    
    // MARK: - Properties
    
    private let rootView: HomeMainView
    var customizingCoordinator: CustomizingCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
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
        bind()
    }
    
    override func loadView() {
        self.view = rootView
    }
    
    // MARK: - Functions
    
    private func bind() {
        rootView.searchBarTappedPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                let searchVC = FlowerSearchViewController()
                self.navigationController?.pushViewController(searchVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func setupNavigationBar() {
        let imageView = UIImageView(image: .whoaLogo)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
}

