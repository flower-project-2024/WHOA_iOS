//
//  FlowerReplacementViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/29/24.
//

import UIKit

class FlowerReplacementViewController: UIViewController {
    
    // MARK: - Initialize
    
    private let titleLabel = CustomTitleLabel(text: "선택한 꽃들이 없다면?")
    
    private let colorOrientedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray5
        return imageView
    }()
    
    private let colorOrientedLabel: UILabel = {
        let label = UILabel()
        label.text = "색감 위주로 대체해주세요"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        return label
    }()
    
    private lazy var colorOrientedView: UIView = {
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorOrientedViewTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private let hashTagOrientedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray5
        return imageView
    }()
    
    private let hashTagOrientedLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃말 위주로 대체해주세요"
        label.font = UIFont(name: "Pretendard-Regular", size: 16)
        return label
    }()
    
    private lazy var hashTagOrientedView: UIView = {
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hashTagOrientedViewTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private let nextButton = NextButton()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        
        view.addSubview(colorOrientedView)
        colorOrientedView.addSubview(colorOrientedImageView)
        colorOrientedView.addSubview(colorOrientedLabel)
        
        view.addSubview(hashTagOrientedView)
        hashTagOrientedView.addSubview(hashTagOrientedImageView)
        hashTagOrientedView.addSubview(hashTagOrientedLabel)
        
        view.addSubview(nextButton)
        
        setupAutoLayout()
        setupButtonActions()
    }
    
    private func setupButtonActions() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
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
    func colorOrientedViewTapped(_ sender: UIView) {
        selectedViewUpdate(
            selectedView: colorOrientedView,
            selectedImageView: colorOrientedImageView,
            selectedLabel: colorOrientedLabel)
        
        unSelectedViewUpdate(
            unSelectedView: hashTagOrientedView,
            unSelectedImageView: hashTagOrientedImageView,
            unSelectedLabel: hashTagOrientedLabel
        )
        
        nextButton.isActive = true
    }
    
    @objc
    func hashTagOrientedViewTapped(_ sender: UIView) {
        selectedViewUpdate(
            selectedView: hashTagOrientedView,
            selectedImageView: hashTagOrientedImageView,
            selectedLabel: hashTagOrientedLabel
        )
        
        unSelectedViewUpdate(
            unSelectedView: colorOrientedView,
            unSelectedImageView: colorOrientedImageView,
            unSelectedLabel: colorOrientedLabel
        )
        
        nextButton.isActive = true
    }
    
    @objc
    func nextButtonTapped() {
        print("다음이동")
    }
}

extension FlowerReplacementViewController {
    private func setupAutoLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        colorOrientedImageView.snp.makeConstraints {
            $0.leading.equalTo(colorOrientedView.snp.leading).offset(18)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        colorOrientedLabel.snp.makeConstraints {
            $0.leading.equalTo(colorOrientedImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        colorOrientedView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        hashTagOrientedImageView.snp.makeConstraints {
            $0.leading.equalTo(hashTagOrientedView.snp.leading).offset(18)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        hashTagOrientedLabel.snp.makeConstraints {
            $0.leading.equalTo(hashTagOrientedImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        hashTagOrientedView.snp.makeConstraints {
            $0.top.equalTo(colorOrientedView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(hashTagOrientedView.snp.bottom).offset(98)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(56)
        }
    }
}
