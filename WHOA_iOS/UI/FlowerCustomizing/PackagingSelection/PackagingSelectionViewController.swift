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
    
    private let noImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray5
        return imageView
    }()
    
    private let noLabel: UILabel = {
        let label = UILabel()
        label.text = "아니요, 사장님께 맡길게요"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        return label
    }()
    
    private lazy var noView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(
            red: 248/255,
            green: 248/255,
            blue: 248/255,
            alpha: 1.0
        )
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(noViewTapped))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let yesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray5
        return imageView
    }()
    
    private let yesLabel: UILabel = {
        let label = UILabel()
        label.text = "네, 제가 작성할게요"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        return label
    }()
    
    private lazy var yesView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(
            red: 248/255,
            green: 248/255,
            blue: 248/255,
            alpha: 1.0
        )
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.clear.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(noViewTapped))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let requirementTextView: UITextView = {
        let view = UITextView()
        view.font = UIFont(name: "Pretendard-Regular", size: 16)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        view.isHidden = true
        return view
    }()
    
    private let placeholder: UILabel = {
        let label = UILabel()
        label.text = "요구사항을 작성해주세요."
        label.textColor = .systemGray3
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        label.isHidden = true
        return label
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
        
        view.addSubview(noView)
        noView.addSubview(noImageView)
        noView.addSubview(noLabel)
        
        view.addSubview(yesView)
        yesView.addSubview(yesImageView)
        yesView.addSubview(yesLabel)
        
        view.addSubview(requirementTextView)
        view.addSubview(placeholder)
        view.addSubview(navigationHStackView)
        
        setupAutoLayout()
        
        requirementTextView.delegate = self
    }
    
    private func bind() {
        viewModel.savedTextDidChanged = { [weak self] savedText in
            self?.nextButton.isActive = savedText.count > 0 ? true : false
        }
    }
    
    private func selectedViewUpdate(
        selectedView: UIView,
        selectedImageView: UIImageView,
        selectedLabel: UILabel
    ) {
        selectedView.backgroundColor = UIColor(
            red: 079/255,
            green: 234/255,
            blue: 191/255,
            alpha: 0.2
        )
        selectedView.layer.borderColor = UIColor(
            red: 079/255,
            green: 234/255,
            blue: 191/255,
            alpha: 1.0
        ).cgColor
        
        selectedImageView.image = UIImage(systemName: "button.programmable")
        selectedImageView.tintColor = UIColor(
            red: 079/255,
            green: 234/255,
            blue: 191/255,
            alpha: 1.0
        )
        
        selectedLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
    
    private func unSelectedViewUpdate(
        unSelectedView: UIView,
        unSelectedImageView: UIImageView,
        unSelectedLabel: UILabel
    ) {
        unSelectedView.backgroundColor = UIColor(
            red: 248/255,
            green: 248/255,
            blue: 248/255,
            alpha: 1.0
        )
        unSelectedView.layer.borderColor = UIColor.clear.cgColor
        
        unSelectedImageView.image = UIImage(systemName: "circle")
        unSelectedImageView.tintColor = .systemGray5
        
        unSelectedLabel.font = UIFont(name: "Pretendard-Regular", size: 16)
        
    }
    
    // MARK: - Actions
    
    @objc
    func noViewTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        
        if view == noView {
            selectedViewUpdate(
                selectedView: noView,
                selectedImageView: noImageView,
                selectedLabel: noLabel)
            
            unSelectedViewUpdate(
                unSelectedView: yesView,
                unSelectedImageView: yesImageView,
                unSelectedLabel: yesLabel
            )
            
            requirementTextView.isHidden = true
            placeholder.isHidden = true
            nextButton.isActive = true
        } else {
            selectedViewUpdate(
                selectedView: yesView,
                selectedImageView: yesImageView,
                selectedLabel: yesLabel
            )
            
            unSelectedViewUpdate(
                unSelectedView: noView,
                unSelectedImageView: noImageView,
                unSelectedLabel: noLabel
            )
            
            requirementTextView.isHidden = false
            
            if viewModel.savedText.count == 0 {
                nextButton.isActive = false
                placeholder.isHidden = false
            }
        }
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
        
        noImageView.snp.makeConstraints {
            $0.leading.equalTo(noView.snp.leading).offset(18)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        noLabel.snp.makeConstraints {
            $0.leading.equalTo(noImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        noView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        yesImageView.snp.makeConstraints {
            $0.leading.equalTo(yesView.snp.leading).offset(18)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        yesLabel.snp.makeConstraints {
            $0.leading.equalTo(yesImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        yesView.snp.makeConstraints {
            $0.top.equalTo(noView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        requirementTextView.snp.makeConstraints {
            $0.top.equalTo(yesView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(120)
        }
        
        placeholder.snp.makeConstraints {
            $0.top.leading.equalTo(requirementTextView).offset(20)
        }
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(56)
        }
        
        navigationHStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-11.5)
        }
    }
}

extension PackagingSelectionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        requirementTextView.layer.borderColor = UIColor.systemMint.cgColor
        
        placeholder.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        requirementTextView.layer.borderColor = UIColor.systemGray5.cgColor
        
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
