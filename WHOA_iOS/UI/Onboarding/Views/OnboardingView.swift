//
//  OnboardingView.swift
//  WHOA_iOS
//
//  Created by KSH on 10/4/24.
//

import UIKit
import Combine

final class OnboardingView: UIView {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let verticalSpacing = 43
        static let scrollViewHeightMultiplier = 587.0 / 375.0
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
    
    var currentPagePublisher: AnyPublisher<Int, Never> {
        currentPageSubject.eraseToAnyPublisher()
    }
    
    var onboardingImagesCount: Int {
        return onboardingImageNames.count
    }
    
    var currentPage: Int {
        return currentPageSubject.value
    }
    
    // MARK: - UI
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .gray04
        pageControl.currentPageIndicatorTintColor = .secondary03
        pageControl.numberOfPages = 4
        return pageControl
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var imageHstackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        onboardingImageNames.forEach { imageName in
            let imageView = UIImageView(image: imageName)
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
        }
        return stackView
    }()
    
    // MARK: - Initialize
    
    init() {
        super.init(frame: .zero)
        setupUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        backgroundColor = .gray02
        [   pageControl,
            scrollView,
        ].forEach(addSubview(_:))
        scrollView.addSubview(imageHstackView)
        setupAutoLayout()
    }
    
    private func bind() {
        currentPageSubject
            .sink { [weak self] currentPage in
                self?.pageControl.currentPage = currentPage
            }
            .store(in: &cancellables)
    }
    
    func setPage(_ page: Int) {
        let offsetX = CGFloat(page) * scrollView.frame.width
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
        }, completion: { _ in
            self.currentPageSubject.send(page)
        })
    }
    
    func updateCurrentPage(to pageIndex: Int) {
        currentPageSubject.send(pageIndex)
    }
}

// MARK: - AutoLayout

extension OnboardingView {
    private func setupAutoLayout() {
        pageControl.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(Metric.verticalSpacing)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        imageHstackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(scrollView.snp.height)
            $0.width.equalTo(scrollView.snp.width).multipliedBy(onboardingImageNames.count)
        }
    }
}
