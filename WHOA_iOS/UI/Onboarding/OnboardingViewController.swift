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
        static let scrollViewHeightMultiplier = 587.0 / 375.0
    }
    
    /// Attributes
    private enum Attributes {
        static let startText = "시작하기"
        static let nextText = "다음"
    }
    
    // MARK: - Properties
    
    private let currentPageSubject: CurrentValueSubject<Int, Never> = .init(0)
    private var cancellables = Set<AnyCancellable>()
    
    private let onboardingImageNames = [
        UIImage.onboardingStep01,
        UIImage.onboardingStep02,
        UIImage.onboardingStep03,
        UIImage.onboardingStep04
    ]
    
    // MARK: - UI
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray04
        pageControl.currentPageIndicatorTintColor = .secondary03
        pageControl.numberOfPages = 4
        return pageControl
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var imageHstackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        // 이미지 추가
        onboardingImageNames.forEach { imageName in
            let imageView = UIImageView(image: imageName)
            imageView.contentMode = .scaleAspectFit
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
        bottomView.backButtonTappedPublisher
            .sink { [weak self] _ in
                self?.showHomeVC()
            }
            .store(in: &cancellables)
        
        bottomView.nextButtonTappedPublisher
            .sink { [weak self] _ in
                self?.handleNextButtonTapped()
            }
            .store(in: &cancellables)
        
        currentPageSubject
            .removeDuplicates()
            .sink { [weak self] pageNumber in
                guard let self = self else { return }
                self.pageControl.currentPage = pageNumber
                let buttonTitle = pageNumber >= self.onboardingImageNames.count - 1 ? Attributes.startText : Attributes.nextText
                self.bottomView.setNextButtonTitle(buttonTitle)
            }
            .store(in: &cancellables)
    }
    
    private func handleNextButtonTapped() {
        let nextPage = currentPageSubject.value + 1
        
        if nextPage >= onboardingImageNames.count {
            showHomeVC()
        } else {
            UIView.animate(withDuration: 0.3) {
                let offsetX = CGFloat(nextPage) * self.scrollView.frame.width
                self.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
            } completion: { _ in
                self.currentPageSubject.send(nextPage)
            }
        }
    }
    
    private func showHomeVC() {
        let tabBarVC = TabBarViewController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = tabBarVC
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        }
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
            $0.height.equalTo(scrollView.snp.width).multipliedBy(Metric.scrollViewHeightMultiplier)
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
        currentPageSubject.send(Int(pageIndex))
    }
}

