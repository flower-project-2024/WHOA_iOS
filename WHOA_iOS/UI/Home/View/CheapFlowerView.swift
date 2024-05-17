//
//  CheapFlowerView.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/7/24.
//

import UIKit
import SnapKit

class CheapFlowerView: UIView {
    
    // MARK: - Views
    private let cheapFlowerLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 주 저렴한 꽃 랭킹"
        label.textColor = UIColor.primary
        label.numberOfLines = 0
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        return label
    }()
    
    private let baseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "4월 첫째 주 기준"
        label.textColor = UIColor.primary
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = UIColor.gray08
        return label
    }()
    
    let topThreeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CheapFlowerInfoCell.self, forCellReuseIdentifier: CheapFlowerInfoCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 86
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // add ui elements
        addSubview(cheapFlowerLabel)
        addSubview(baseDateLabel)
        addSubview(topThreeTableView)
        
        // constraints
        cheapFlowerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        baseDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cheapFlowerLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }
        
        topThreeTableView.snp.makeConstraints { make in
            make.top.equalTo(cheapFlowerLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}