//
//  ViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/4/24.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    var todaysFlowerView = TodaysFlowerView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(todaysFlowerView)

        setup()
    }

    // MARK: - Helper
    private func setup(){
        setupUI()
        todaysFlowerView.decorateButton.addTarget(self, action: #selector(decorateButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI(){
        todaysFlowerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Actions
    @objc func decorateButtonTapped(){
        print("---이 꽃으로 꾸미기---")
    }
}
