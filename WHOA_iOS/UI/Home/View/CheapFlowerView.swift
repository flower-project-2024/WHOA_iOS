//
//  CheapFlowerView.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/7/24.
//

import UIKit
import SnapKit

final class CheapFlowerView: UIView {
    
    // MARK: - Views
    
    private let cheapFlowerLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 주 저렴한 꽃 랭킹"
        label.textColor = UIColor.customPrimary
        label.numberOfLines = 0
        label.font = .Pretendard(size: 20, family: .Bold)
        return label
    }()
    
    private let baseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray07
        label.numberOfLines = 2
        return label
    }()
    
    let topThreeTableView: CustomTableView = {
        let tableView = CustomTableView()
        tableView.register(CheapFlowerInfoCell.self, forCellReuseIdentifier: CheapFlowerInfoCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 86
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        setupConstraints()        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func addViews() {
        addSubview(cheapFlowerLabel)
        addSubview(baseDateLabel)
        addSubview(topThreeTableView)
    }
    
    private func setupConstraints() {
        cheapFlowerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        baseDateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.trailing.equalToSuperview()
        }
        
        topThreeTableView.snp.makeConstraints { make in
            make.top.equalTo(cheapFlowerLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setBaseDateLabel(viewModel: HomeViewModel) {
        let data = viewModel.calculateCheapFlowerBaseDate()
        let newText = "\(data[0])월 \(data[1]) 기준\n출처: 화훼유통정보시스템"
        baseDateLabel.attributedText = makeBaseDateAttributedText(dateText: newText)
    }
    
    private func makeBaseDateAttributedText(dateText: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = .right

        let attributedString = NSMutableAttributedString(
            string: dateText,
            attributes: [
                .font: UIFont.Pretendard(size: 12, family: .Regular),
                .foregroundColor: UIColor.gray07,
                .paragraphStyle: paragraphStyle
            ]
        )

        if let range = dateText.range(of: "출처: 화훼유통정보시스템") {
            attributedString.addAttributes([
                .font: UIFont.Pretendard(size: 10, family: .Light)
            ], range: NSRange(range, in: dateText))
        }

        return attributedString
    }
}
