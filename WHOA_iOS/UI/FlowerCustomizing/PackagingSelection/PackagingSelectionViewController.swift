//
//  PackagingSelectionViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 3/9/24.
//

import UIKit

class PackagingSelectionViewController: UIViewController {
    
    // MARK: - Initialize
    
    let viewModel = PackagingSelectionViewModel()
    
    // MARK: - UI
    
    private let exitButton = ExitButton()
    private let progressHStackView = CustomProgressHStackView(numerator: 4, denominator: 7)
    private let titleLabel = CustomTitleLabel(text: "원하는 포장지 종류가 있나요?")
    
    private let managerAssignButton: SpacebarButton = {
        let button = SpacebarButton(title: "아니요, 사장님께 맡길게요")
        button.addTarget(self, action: #selector(assignButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let myselfAssignButton: SpacebarButton = {
        let button = SpacebarButton(title: "네, 제가 작성할게요")
        button.addTarget(self, action: #selector(assignButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let requirementTextView: UITextView = {
        let view = UITextView()
        view.font = .Pretendard()
        view.textColor = .black
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray4.cgColor
        view.textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        view.isHidden = true
        return view
    }()
    
    private let placeholder: UILabel = {
        let label = UILabel()
        label.text = "요구사항을 작성해주세요."
        label.textColor = .gray6
        label.font = .Pretendard()
        label.isHidden = true
        return label
    }()
    
    private let borderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    
    private let backButton: BackButton = {
        let button = BackButton(isActive: true)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: NextButton = {
        let button = NextButton()
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var navigationHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            backButton,
            nextButton
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 9
        return stackView
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
        
        view.addSubview(exitButton)
        view.addSubview(progressHStackView)
        view.addSubview(titleLabel)
        
        view.addSubview(managerAssignButton)
        view.addSubview(myselfAssignButton)
        
        view.addSubview(requirementTextView)
        view.addSubview(placeholder)
        
        view.addSubview(borderLine)
        view.addSubview(navigationHStackView)
        
        setupAutoLayout()
        
        requirementTextView.delegate = self
    }
    
    private func bind() {
        viewModel.savedTextDidChanged = { [weak self] savedText in
            self?.nextButton.isActive = savedText.count > 0 ? true : false
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func assignButtonTapped(_ sender: UIButton) {
//        let Alternatives: AlternativesType = sender === hashTagOrientedButton ?
//            .hashTagOriented : .colorOriented
        
//        viewModel.getAlternatives(alternatives: Alternatives)
    }
    
    @objc
    func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    func nextButtonTapped() {
        print("다음이동")
    }
}

extension PackagingSelectionViewController {
    private func setupAutoLayout() {
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(17)
            $0.leading.equalToSuperview().offset(22)
        }
        
        progressHStackView.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).offset(29)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(19.5)
            $0.height.equalTo(12.75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressHStackView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(91)
        }
        
        managerAssignButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        myselfAssignButton.snp.makeConstraints {
            $0.top.equalTo(managerAssignButton.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        requirementTextView.snp.makeConstraints {
            $0.top.equalTo(myselfAssignButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(120)
        }
        
        placeholder.snp.makeConstraints {
            $0.top.leading.equalTo(requirementTextView).offset(20)
        }
        
        borderLine.snp.makeConstraints {
            $0.top.equalTo(navigationHStackView.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(3)
        }
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(56)
        }
        
        navigationHStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            $0.leading.trailing.equalToSuperview().inset(18)
        }
    }
}

extension PackagingSelectionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        requirementTextView.layer.borderColor = UIColor.second1.cgColor
        
        placeholder.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        requirementTextView.layer.borderColor = UIColor.gray4.cgColor
        
        if textView.text.count == 0 {
            placeholder.isHidden = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) /// 화면을 누르면 키보드 내려가게 하는 것
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.savedText = textView.text
        print(viewModel.savedText)
    }
}
