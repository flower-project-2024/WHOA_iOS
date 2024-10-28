//
//  FlowerImageView.swift
//  WHOA_iOS
//
//  Created by KSH on 10/17/24.
//

import UIKit
import Combine

final class FlowerImageView: UIView {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let imageViewSize = 48.0
        static let minusImageViewInset = 6.0
        static let minusImageViewSize = 12.0
    }
    
    /// Attributes
    private enum Attributes {
    }
    
    // MARK: - Properties
    
    private let minusImageTappedSubject = PassthroughSubject<Int, Never>()
    
    var valuePublisher: AnyPublisher<Int, Never> {
        return minusImageTappedSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UI
    
    private lazy var flowerImageView1: UIImageView = buildFlowerImageView()
    private lazy var minusImageView1: UIImageView = buildMinusImageView(tag: 0)
    
    private lazy var flowerImageView2: UIImageView = buildFlowerImageView()
    private lazy var minusImageView2: UIImageView = buildMinusImageView(tag: 1)
    
    private lazy var flowerImageView3: UIImageView = buildFlowerImageView()
    private lazy var minusImageView3: UIImageView = buildMinusImageView(tag: 2)
    
    private lazy var flowerImageViewHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            flowerImageView1,
            flowerImageView2,
            flowerImageView3
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        
        [
            flowerImageViewHStackView,
            minusImageView1,
            minusImageView2,
            minusImageView3
        ].forEach(addSubview(_:))
        
        setupAutoLayout()
    }
    
    func setImages(urlStrings: [String]) {
        let imageViews = [flowerImageView1, flowerImageView2, flowerImageView3]
        
        for (i, imageView) in imageViews.enumerated() {
            if i < urlStrings.count {
                ImageProvider.shared.setImage(into: imageView, from: urlStrings[i])
                updateMinusVisibility(for: imageView, hasImage: true)
            } else {
                imageView.image = nil
                updateMinusVisibility(for: imageView, hasImage: false)
            }
        }
    }
    
    private func updateMinusVisibility(for imageView: UIImageView, hasImage: Bool) {
        switch imageView {
        case flowerImageView1:
            minusImageView1.isHidden = !hasImage
        case flowerImageView2:
            minusImageView2.isHidden = !hasImage
        case flowerImageView3:
            minusImageView3.isHidden = !hasImage
        default:
            break
        }
    }
    
    private func buildFlowerImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray02
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.gray04.cgColor
        return imageView
    }
    
    private func buildMinusImageView(tag: Int) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = .minusButton
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.tag = tag
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(minusImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }
    
    // MARK: - Actions
    
    @objc
    func minusImageViewTapped(_ sender: UITapGestureRecognizer) {
        guard let minusImageView = sender.view as? UIImageView else { return }
        minusImageView.isHidden = true
        minusImageTappedSubject.send(minusImageView.tag)
    }
}

// MARK: - AutoLayout

extension FlowerImageView {
    private func setupAutoLayout() {
        flowerImageViewHStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        flowerImageView1.snp.makeConstraints {
            $0.size.equalTo(Metric.imageViewSize)
        }
        
        minusImageView1.snp.makeConstraints {
            $0.top.trailing.equalTo(flowerImageView1).inset(Metric.minusImageViewInset)
            $0.size.equalTo(Metric.minusImageViewSize)
        }
        
        minusImageView2.snp.makeConstraints {
            $0.top.trailing.equalTo(flowerImageView2).inset(Metric.minusImageViewInset)
            $0.size.equalTo(Metric.minusImageViewSize)
        }
        
        minusImageView3.snp.makeConstraints {
            $0.top.trailing.equalTo(flowerImageView3).inset(Metric.minusImageViewInset)
            $0.size.equalTo(Metric.minusImageViewSize)
        }
    }
}
