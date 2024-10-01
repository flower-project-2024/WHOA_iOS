//
//  OnboardingViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 9/27/24.
//

import UIKit
import SnapKit
import Combine

final class OnboardingViewController: UIViewController {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let verticalSpacing = 43
    }
    
    /// Attributes
    private enum Attributes {
        static let onboardingStep01 = "OnboardingStep01"
        static let onboardingStep02 = "OnboardingStep02"
        static let onboardingStep03 = "OnboardingStep03"
        static let onboardingStep04 = "OnboardingStep04"
    }
    
    // MARK: - Properties
    
    private var currentPage: Int = 0
    private var cancellables = Set<AnyCancellable>()
    private let onboardingImageNames = [
        Attributes.onboardingStep01,
        Attributes.onboardingStep02,
        Attributes.onboardingStep03,
        Attributes.onboardingStep04
    ]
    
    // MARK: - UI
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray04
        pageControl.currentPageIndicatorTintColor = .secondary03
        return pageControl
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.bounces = false
        scrollView.delegate = self
        pageControl.numberOfPages = onboardingImageNames.count
        return scrollView
    }()
    
    private lazy var imageHstackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        
        // 이미지 추가
        for imageName in onboardingImageNames {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            stackView.addArrangedSubview(imageView)
        }
        return stackView
    }()
    
    private let bottomView = CustomBottomView(
        backButtonState: .enabled,
        nextButtonEnabled: true,
        backButtonTitle: "건너뛰기"
    )
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .gray02
        
        [   pageControl,
            scrollView,
            bottomView
        ].forEach(view.addSubview(_:))
        scrollView.addSubview(imageHstackView)
        setupAutoLayout()
    }
    
    private func bind() {
    }
}

// MARK: - AutoLayout

extension OnboardingViewController {
    private func setupAutoLayout() {
        pageControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Metric.verticalSpacing)
            $0.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(Metric.verticalSpacing)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(scrollView.snp.width).multipliedBy(587.0 / 375.0)
        }
        
        imageHstackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(scrollView.snp.height)
            $0.width.equalTo(scrollView.snp.width).multipliedBy(onboardingImageNames.count)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

