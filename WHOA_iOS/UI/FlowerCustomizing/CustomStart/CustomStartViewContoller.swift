//
//  CustomStartViewContoller.swift
//  WHOA_iOS
//
//  Created by KSH on 8/15/24.
//

import UIKit

final class CustomStartViewContoller: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI
    
    private let headerView = CustomStartHeaderView()
    private let customStartView = CustomStartView()
    
    // MARK: - Initialize
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configNavigationBar(isHidden: false)
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [
            headerView,
            customStartView
        ].forEach(view.addSubview(_:))
        
        setupAutoLayout()
    }
    
    private func bind() {
    }
}

// MARK: - AutoLayout

extension CustomStartViewContoller {
    private func setupAutoLayout() {
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(375)
        }
        
        customStartView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
}
