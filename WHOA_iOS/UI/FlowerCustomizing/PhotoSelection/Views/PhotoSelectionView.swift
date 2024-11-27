//
//  PhotoSelectionView.swift
//  WHOA_iOS
//
//  Created by KSH on 11/22/24.
//

import UIKit
import Combine

final class PhotoSelectionView: UIView {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let imageViewWidth = UIScreen.main.bounds.width > 375 ? 150.0 : 130.0
        static let imageViewHeightMultiplier = 1.04
        static let minusButtonInset = 5.0
        static let minusButtonSize = 16.0
    }
    
    /// Attributes
    private enum Attributes {
        static let plusImage = UIImage(systemName: "plus.circle")
        static let photoIcon = UIImage(named: "PhotoIcon")
        static let minusButton = UIImage(named: "MinusButton")
    }
    
    // MARK: - Properties
    
    private let addImageButtonTappedSubject = PassthroughSubject<Void, Never>()
    private let minusButtonTappedSubject = PassthroughSubject<Int, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var addImageButtonTappedPublisher: AnyPublisher<Void, Never> {
        return addImageButtonTappedSubject.eraseToAnyPublisher()
    }
    
    var minusButtonTappedPublisher: AnyPublisher<Int, Never> {
        return minusButtonTappedSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UI
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        return scrollView
    }()
    
    private lazy var addImageButton: UIImageView = {
        let imageView = buildImageView(
            image: Attributes.plusImage,
            backgroundColor: .gray02,
            tintColor: .black
        )
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addImageButtonTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private lazy var photoImageView1: UIImageView = {
        let imageView = buildImageView(
            image: Attributes.photoIcon,
            backgroundColor: .gray02
        )
        return imageView
    }()
    
    private lazy var minusImageView1: UIImageView = {
        let imageView = buildImageView(
            image: Attributes.minusButton,
            contentMode: .scaleAspectFill,
            cornerRadius: 0,
            isHidden: true
        )
        imageView.tag = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(minusButtonTapped(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private lazy var photoImageView2: UIImageView = {
        let imageView = buildImageView(
            image: Attributes.photoIcon,
            backgroundColor: .gray02
        )
        return imageView
    }()
    
    private lazy var minusImageView2: UIImageView = {
        let imageView = buildImageView(
            image: Attributes.minusButton,
            contentMode: .scaleAspectFill,
            cornerRadius: 0,
            isHidden: true
        )
        imageView.tag = 1
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(minusButtonTapped(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private lazy var photoImageView3: UIImageView = {
        let imageView = buildImageView(
            image: Attributes.photoIcon,
            backgroundColor: .gray02
        )
        return imageView
    }()
    
    private lazy var minusImageView3: UIImageView = {
        let imageView = buildImageView(
            image: Attributes.minusButton,
            contentMode: .scaleAspectFill,
            cornerRadius: 0,
            isHidden: true
        )
        imageView.tag = 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(minusButtonTapped(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            addImageButton,
            photoImageView1,
            photoImageView2,
            photoImageView3
        ])
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
        backgroundColor = .white
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        photoImageView1.addSubview(minusImageView1)
        photoImageView2.addSubview(minusImageView2)
        photoImageView3.addSubview(minusImageView3)
        
        setupAutoLayout()
    }
    
    private func buildImageView(
        image: UIImage?,
        backgroundColor: UIColor? = .clear,
        tintColor: UIColor? = nil,
        contentMode: UIView.ContentMode = .center,
        cornerRadius: CGFloat = 10,
        isHidden: Bool = false
    ) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.tintColor = tintColor
        imageView.backgroundColor = backgroundColor
        imageView.contentMode = contentMode
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.masksToBounds = cornerRadius > 0
        imageView.isHidden = isHidden
        return imageView
    }
    
    func upadtePhotoImageView(photosData: [Data]) {
        let photoImageViews = [
            photoImageView1,
            photoImageView2,
            photoImageView3
        ]
        let minusImageViews = [
            minusImageView1,
            minusImageView2,
            minusImageView3
        ]
        
        for (index, photoData) in photosData.enumerated() {
            photoImageViews[index].image = UIImage(data: photoData)
            photoImageViews[index].contentMode = .scaleAspectFill
            minusImageViews[index].isHidden = false
        }
        
        for index in photosData.count..<photoImageViews.count {
            photoImageViews[index].image = Attributes.photoIcon
            photoImageViews[index].contentMode = .center
            minusImageViews[index].isHidden = true
        }
    }
    // MARK: - Actions
    
    @objc
    private func addImageButtonTapped() {
        addImageButtonTappedSubject.send()
    }
    
    @objc
    private func minusButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else { return }
        minusButtonTappedSubject.send(index)
    }
}

// MARK: - AutoLayout

extension PhotoSelectionView {
    private func setupAutoLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.height.equalToSuperview()
        }
        
        photoImageView1.snp.makeConstraints {
            $0.width.equalTo(Metric.imageViewWidth)
            $0.height.equalTo(photoImageView1.snp.width).multipliedBy(Metric.imageViewHeightMultiplier)
        }
        
        [minusImageView1, minusImageView2, minusImageView3].forEach { imageView in
            imageView.snp.makeConstraints {
                $0.top.trailing.equalToSuperview().inset(Metric.minusButtonInset)
                $0.size.equalTo(Metric.minusButtonSize)
            }
        }
    }
}

