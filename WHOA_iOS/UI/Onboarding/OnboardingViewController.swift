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
        static let startText = "시작하기"
        static let nextText = "다음"
    }
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI
    
    private let onboardingView = OnboardingView()
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
        [
            onboardingView,
            bottomView
        ].forEach(view.addSubview(_:))
        onboardingView.scrollView.delegate = self
        setupAutoLayout()
    }
    
    private func bind() {
        onboardingView.currentPagePublisher
            .removeDuplicates()
            .sink { [weak self] pageNumber in
                self?.updateNextButtonTitle(forPage: pageNumber)
            }
            .store(in: &cancellables)
        
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
    }
    
    private func updateNextButtonTitle(forPage pageNumber: Int) {
        let buttonTitle = pageNumber >= onboardingView.onboardingImagesCount - 1 ? Attributes.startText : Attributes.nextText
        bottomView.setNextButtonTitle(buttonTitle)
    }
    
    private func handleNextButtonTapped() {
        let currentPage = onboardingView.currentPage
        let nextPage = currentPage + 1
        
        if nextPage >= onboardingView.onboardingImagesCount {
            showHomeVC()
        } else {
            onboardingView.setPage(nextPage)
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
        onboardingView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Metric.verticalSpacing)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.bottom)
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
        let pageIndex = round(scrollView.contentOffset.x / onboardingView.frame.width)
        onboardingView.updateCurrentPage(to: Int(pageIndex))
    }
}

