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
    private let homeVM: HomeVM
    private var cancellables = Set<AnyCancellable>()
    
    var customizingCoordinator: CustomizingCoordinator?
    
    // MARK: - Initialize
    
    init(homeVM: HomeVM) {
        self.rootView = HomeMainView()
        self.homeVM = homeVM
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
        let input = HomeVM.Input(viewDidLoad: Just(()).eraseToAnyPublisher())
        let output = homeVM.transform(input: input)
        
        output.fetchTodaysFlower
            .receive(on: DispatchQueue.main)
            .sink { [weak self] flowerData in
                self?.rootView.updateTodaysFlower(with: flowerData)
            }
            .store(in: &cancellables)
        
        output.fetchCheapFlowerRankings
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cheapRanking in
                self?.rootView.updateCheapFlowerRankings(cheapRanking)
            }
            .store(in: &cancellables)
        
        output.errorMessage
            .sink { [weak self] errorMessage in
                self?.showAlert(title: errorMessage)
            }
            .store(in: &cancellables)
        
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

