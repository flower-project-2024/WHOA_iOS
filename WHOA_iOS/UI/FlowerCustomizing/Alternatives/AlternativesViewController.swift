//
//  FlowerReplacementViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/29/24.
//

import UIKit

class AlternativesViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel = AlternativesViewModel()
    
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
        
        bind()
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
    
    func bind() {
        viewModel.$selectedButtonType
                .receive(on: RunLoop.main)
                .sink { [weak self] selectedType in
                    guard let self = self else { return }
                    self.colorOrientedButton.isSelected = selectedType == .colorOriented
                    self.hashTagOrientedButton.isSelected = selectedType == .hashTagOriented

                    self.colorOrientedButton.configuration = self.colorOrientedButton.configure(isSelected: self.colorOrientedButton.isSelected)
                    self.hashTagOrientedButton.configuration = self.hashTagOrientedButton.configure(isSelected: self.hashTagOrientedButton.isSelected)
                }
                .store(in: &viewModel.cancellables)
        
        viewModel.$alternativesModel
            .receive(on: RunLoop.main)
            .map { alternatives in
                return alternatives != nil
            }
            .assign(to: \.isActive, on: nextButton)
            .store(in: &viewModel.cancellables)
    }
    
    // MARK: - Actions
    
    @objc
    private func spacebarButtonTapped(_ sender: UIButton) {
        guard let button = sender as? SpacebarButton else { return }
        
        if button === hashTagOrientedButton {
               viewModel.selectedButtonType = .hashTagOriented
           } else if button === colorOrientedButton {
               viewModel.selectedButtonType = .colorOriented
           }
        
        viewModel.getAlternatives()
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
