//
//  FlowerReplacementViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/29/24.
//

import UIKit

class AlternativesViewController: UIViewController {
    
    // MARK: - UI
    
    private let titleLabel = CustomTitleLabel(text: "선택한 꽃들이 없다면?")
    
    private let colorOrientedButton: SpacebarButton = {
        let button = SpacebarButton(title: "\(AlternativesType.colorOriented.rawValue)로 대체해주세요")
        button.addTarget(self, action: #selector(spacebarButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let hashTagOrientedButton: SpacebarButton = {
        let button = SpacebarButton(title: "\(AlternativesType.hashTagOriented.rawValue)로 대체해주세요")
        button.addTarget(self, action: #selector(spacebarButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: NextButton = {
        let button = NextButton()
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        
        view.addSubview(colorOrientedButton)
        view.addSubview(hashTagOrientedButton)
        
        view.addSubview(nextButton)
        
        
        setupAutoLayout()
    }
    
    private func updateNextButtonState() {
        if colorOrientedButton.isSelected || hashTagOrientedButton.isSelected {
            nextButton.isActive = true
        } else {
            nextButton.isActive = false
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func spacebarButtonTapped(_ sender: UIButton) {
        guard let button = sender as? SpacebarButton,
              let title = button.titleLabel?.text
        else { return }
        
        button.isSelected.toggle()
        button.configuration = button.configure(title: title, isSelected: button.isSelected)
        
        let otherButton = (button === hashTagOrientedButton) ?
        colorOrientedButton : hashTagOrientedButton
        
        otherButton.isSelected = false
        otherButton.configuration = button.configure(title: otherButton.titleLabel?.text ?? "", isSelected: false)
        
        updateNextButtonState()
    }
    
    @objc
    func nextButtonTapped() {
        print("다음이동")
    }
    
}

extension AlternativesViewController {
    private func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        colorOrientedButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        hashTagOrientedButton.snp.makeConstraints {
            $0.top.equalTo(colorOrientedButton.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(hashTagOrientedButton.snp.bottom).offset(98)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(56)
        }
    }
}
