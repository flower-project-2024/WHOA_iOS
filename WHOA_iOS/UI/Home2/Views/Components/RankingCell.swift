//
//  RankingCell.swift
//  WHOA_iOS
//
//  Created by 김세훈 on 1/13/25.
//

import UIKit
import Combine

final class RankingCell: UICollectionViewCell {
    
    // MARK: - Enums
    
    /// Metric
    private enum Metric {
        static let flowerImageViewHeightMultiplier: CGFloat = 1.0
        static let rankingLabelTopOffset: CGFloat = 12.0
        static let elementLeadingOffset: CGFloat = 17.0
        static let priceInfoHStackViewTrailingOffset: CGFloat = -10.0
        static let moveToDetailImageViewWidth: CGFloat = 9.0
        static let moveToDetailImageViewHeight: CGFloat = 16.0
    }
    
    // MARK: - Properties
    
    private let cellTapSubject = PassthroughSubject<Void, Never>()
    var cancellables = Set<AnyCancellable>()

    var cellTapPublisher: AnyPublisher<Void, Never> {
        cellTapSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UI
    
    private let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.layer.borderColor = UIColor.gray06.cgColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    private let rankingLabel: UILabel =  {
        let label = UILabel()
        label.text = "1"
        label.font = .Pretendard(size: 20, family: .Medium)
        label.textColor = .customPrimary
        return label
    }()
    
    private let flowerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "히아신스"
        label.font = .Pretendard(size: 16, family: .SemiBold)
        label.textColor = UIColor.customPrimary
        return label
    }()
    
    private let flowerLanguageLabel: UILabel =  {
        let label = UILabel()
        label.text = "영원한 사랑"
        label.font = .Pretendard(size: 12, family: .Regular)
        label.textColor = .gray07
        return label
    }()
    
    private lazy var textVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            flowerNameLabel,
            flowerLanguageLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "2,100"
        label.font = .Pretendard(size: 16, family: .Bold)
        label.textColor = UIColor.secondary04
        return label
    }()
    
    private let rankingChangeLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard(size: 13)
        label.textColor = .gray06
        label.text = "-"
        return label
    }()
    
    private let moveToDetailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.chevronRight.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.gray07
        return imageView
    }()
    
    private lazy var priceInfoHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            priceLabel,
            rankingChangeLabel,
            moveToDetailImageView
        ])
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()
    
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
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
    
    // MARK: - Functions
    
    private func addSubviews() {
        [
            flowerImageView,
            rankingLabel,
            textVStackView,
            priceInfoHStackView,
        ].forEach(addSubview(_:))
    }
    
    private func setupUI() {
        backgroundColor = .white
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
    }
    
    private func configureRankChange(_ change: Int) {
        switch change {
        case let x where x > 0:
            rankingChangeLabel.textColor = .secondary04
            rankingChangeLabel.text = "▲  \(x)"
            rankingChangeLabel.font = .Pretendard(size: 13)
        case let x where x < 0:
            rankingChangeLabel.textColor = .gray06
            rankingChangeLabel.text = "▼  \(-x)"
            rankingChangeLabel.font = .Pretendard(size: 13)
        default:
            rankingChangeLabel.textColor = .gray06
            rankingChangeLabel.text = "-"
            rankingChangeLabel.font = .Pretendard(size: 20)
        }
    }
    
    func configureCheapRanking(rank: Int, model: CheapFlowerModel) {
        rankingLabel.text = "\(rank)"
        moveToDetailImageView.alpha = (model.flowerId == nil) ? 0 : 1
        flowerNameLabel.text = model.flowerRankingName
        priceLabel.text = model.flowerRankingPrice.formatNumberInThousands() + "원"
        flowerLanguageLabel.text = model.flowerRankingLanguage?.components(separatedBy: ",").first
        priceLabel.isHidden = false
        rankingChangeLabel.isHidden = true
        
        if let flowerImage = model.flowerRankingImg {
            ImageProvider.shared.setImage(into: flowerImageView, from: flowerImage)
        } else {
            flowerImageView.image = [.flowerIllust1, .flowerIllust2,.flowerIllust3].randomElement()
        }
    }
    
    func configurePopularRanking(rank: Int, model: popularityData) {
        rankingLabel.text = "\(rank)"
        flowerNameLabel.text = model.flowerName
        flowerLanguageLabel.text = model.flowerLanguage.components(separatedBy: ",").first
        configureRankChange(model.rankDifference)
        ImageProvider.shared.setImage(into: flowerImageView, from: model.flowerImageUrl)
        priceLabel.isHidden = true
        rankingChangeLabel.isHidden = false
        moveToDetailImageView.alpha = (model.flowerId == 0) ? 0 : 1
    }
    
    // MARK: - Actions
    
    @objc
    private func cellTapped() {
        cellTapSubject.send()
    }
}

// MARK: - AutoLayout

extension RankingCell {
    private func setupAutoLayout() {
        flowerImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(flowerImageView.snp.height).multipliedBy(Metric.flowerImageViewHeightMultiplier)
        }
        
        rankingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Metric.rankingLabelTopOffset)
            $0.leading.equalTo(flowerImageView.snp.trailing).offset(Metric.elementLeadingOffset)
        }
        
        textVStackView.snp.makeConstraints {
            $0.top.equalTo(rankingLabel.snp.top)
            $0.leading.equalTo(rankingLabel.snp.trailing).offset(Metric.elementLeadingOffset)
        }
        
        priceInfoHStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(Metric.priceInfoHStackViewTrailingOffset)
        }
        
        moveToDetailImageView.snp.makeConstraints {
            $0.width.equalTo(Metric.moveToDetailImageViewWidth)
            $0.height.equalTo(Metric.moveToDetailImageViewHeight)
        }
    }
}
