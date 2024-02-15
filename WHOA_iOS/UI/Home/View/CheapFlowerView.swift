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
    let cheapFlowerLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘따라 저렴한 꽃을\n알아보아요"
        label.numberOfLines = 0
        label.font = UIFont(name: "Pretendard-Bold", size: 20)
        return label
    }()
    
    let baseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "4월 첫째주 기준"
        label.font = UIFont(name: "Pretendard-Medium", size: 12)
        label.textColor = .lightGray
        return label
    }()
    
    let topThreeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CheapFlowerInfoCell.self, forCellReuseIdentifier: CheapFlowerInfoCell.identifier)
        tableView.separatorStyle = .none
//        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
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
            make.top.equalTo(cheapFlowerLabel.snp.bottom).offset(1)
            make.leading.equalTo(cheapFlowerLabel.snp.leading)
        }
        
        topThreeTableView.snp.makeConstraints { make in
            make.top.equalTo(baseDateLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
