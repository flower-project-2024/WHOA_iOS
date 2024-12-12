//
//  HomeMainView.swift
//  WHOA_iOS
//
//  Created by KSH on 12/12/24.
//

import UIKit
import SnapKit

final class HomeMainView: UIView {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let searchBarViewTopOffset = 24.0
        static let sideMargin = 20.0
        static let searchBarViewHeight = 54.0
    }

    // MARK: - Properties
    
    private let searchBarView = SearchBarView()
    
    // MARK: - initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupAutoLayout()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func addSubviews() {
        [
            searchBarView
        ].forEach(addSubview(_:))
    }
    
    private func setupUI() {
        backgroundColor = .white
    }
}

// MARK: - AutoLayout

extension HomeMainView {
    private func setupAutoLayout() {
        searchBarView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(Metric.searchBarViewTopOffset)
            $0.leading.trailing.equalToSuperview().inset(Metric.sideMargin)
            $0.height.equalTo(Metric.searchBarViewHeight)
        }
    }
}
