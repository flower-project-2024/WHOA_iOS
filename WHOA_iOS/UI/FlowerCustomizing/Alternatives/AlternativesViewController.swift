//
//  FlowerReplacementViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/29/24.
//

import UIKit

class AlternativesViewController: UIViewController {
    
    // MARK: - Properties
    
    let viewModel: AlternativesViewModel
    weak var coordinator: CustomizingCoordinator?
    
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
    
    // MARK: - Initialize
    
    init(viewModel: AlternativesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let Alternatives: AlternativesType = sender === hashTagOrientedButton ?
            .hashTagOriented : .colorOriented
        
        viewModel.getAlternatives(alternatives: Alternatives)
    }
    
    @objc
    func nextButtonTapped() {
        guard let alternative = viewModel.alternativesModel?.AlternativesType else { return }
        coordinator?.showPackagingSelectionVC(from: self, alternative: alternative)
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
            $0.height.equalTo(56.adjustedH())
        }
        
        hashTagOrientedButton.snp.makeConstraints {
            $0.top.equalTo(colorOrientedButton.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56.adjustedH())
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(hashTagOrientedButton.snp.bottom).offset(98.adjustedH())
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(56.adjustedH())
        }
    }
}
