//
//  PhotoCell.swift
//  WHOA_iOS
//
//  Created by KSH on 3/15/24.
//

import UIKit
import Photos

enum SelectionOrder {
    case none
    case selected(Int)
}

struct PhotoCellInfo {
    let phAsset: PHAsset
    let image: UIImage?
    let selectedOrder: SelectionOrder
}

final class PhotoCell: UICollectionViewCell {
    static let id = "PhotoCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let highlightedView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 5.0
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.layer.borderColor = UIColor.secondary03.cgColor
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let orderLabel: UILabel = {
        let label = HashTagCustomLabel(padding: UIEdgeInsets(top: 3.0, left: 9.0, bottom: 3.0, right: 9.0))
        label.textColor = .customPrimary
        label.backgroundColor = .secondary03
        label.font = .Pretendard(size: 16, family: .SemiBold)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 13
        return label
    }()
    
    // MARK: Initializer
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepare(info: nil)
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        layer.masksToBounds = true // 주의: 이 값을 안주면 이미지가 셀의 다른 영역을 침범하는 영향을 주는것
        
        contentView.addSubview(imageView)
        imageView.addSubview(highlightedView)
        highlightedView.addSubview(orderLabel)
        
        setupAutoLayout()
    }
    
    func prepare(info: PhotoCellInfo?) {
        imageView.image = info?.image
        
        if case let .selected(order) = info?.selectedOrder {
            highlightedView.isHidden = false
            orderLabel.text = String(order)
        } else {
            highlightedView.isHidden = true
        }
    }
    
    func getImage() -> UIImage? {
        return imageView.image
    }
}

extension PhotoCell {
    private func setupAutoLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        highlightedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        orderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
}
