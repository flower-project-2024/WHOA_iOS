//
//  PurposeViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/5/24.
//

import UIKit
import SnapKit

final class PurposeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: PurposeViewModel
    weak var coordinator: CustomizingCoordinator?
    
    // MARK: - UI
    
    private lazy var headerView = CustomHeaderView(currentVC: self, coordinator: coordinator)
    private let purposeView = PurposeView()
    private let bottomView = CustomBottomView()
    
    // MARK: - Initialize
    
    init(viewModel: PurposeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        extendedLayoutIncludesOpaqueBars = false
        navigationController?.setNavigationBarHidden(false, animated: false)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        view.addSubview(purposeView)
        view.addSubview(bottomView)
        setupAutoLayout()
    }
}

// MARK: - AutoLayout

extension PurposeViewController {
    private func setupAutoLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-21)
        }
        
        purposeView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(21)
            $0.trailing.equalToSuperview().offset(-21)
            $0.bottom.equalTo(bottomView.snp.top).offset(-45.adjustedH(basedOnHeight: 852))
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
