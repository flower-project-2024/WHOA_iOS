//
//  ViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/4/24.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    var todaysFlowerView = TodaysFlowerView()
    var cheapFlowerView = CheapFlowerView()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(todaysFlowerView)
        contentView.addSubview(cheapFlowerView)
//        view.addSubview(todaysFlowerView)
//        view.addSubview(cheapFlowerView)
        
        setupConstraints()
        
        todaysFlowerView.decorateButton.addTarget(self, action: #selector(decorateButtonTapped), for: .touchUpInside)

        cheapFlowerView.topThreeTableView.dataSource = self
        cheapFlowerView.topThreeTableView.delegate = self
        
    }

    // MARK: - Helper
    
    private func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.frameLayoutGuide)
            //make.width.equalTo(scrollView.frameLayoutGuide)  // 세로 스크롤
            //make.height.equalTo(1200)
        }
        
        todaysFlowerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        cheapFlowerView.snp.makeConstraints { make in
            make.top.equalTo(todaysFlowerView.snp.bottom).offset(65)
            make.leading.trailing.equalToSuperview().inset(21)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    @objc func decorateButtonTapped(){
        print("---이 꽃으로 꾸미기---")
    }
}

// MARK: - Extensions
extension HomeViewController : UITableViewDataSource {
    // 섹션 당 셀 개수: 3
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    // 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CheapFlowerInfoCell.identifier, for: indexPath) as! CheapFlowerInfoCell
        cell.flowerImageView.image = UIImage(systemName: "ticket")
        cell.rankingLabel.text = "\(indexPath.row + 1)"
        return cell
    }
    
    // TableView의 rowHeight속성에 AutometicDimension을 통해 테이블의 row가 유동적이라는 것을 선언
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select \(indexPath.row)")
    }
}

extension UIScrollView {
    func updateContentSize() {
        let unionCalculatedTotalRect = recursiveUnionInDepthFor(view: self)
        
        // 계산된 크기로 컨텐츠 사이즈 설정
        self.contentSize = CGSize(width: self.frame.width, height: unionCalculatedTotalRect.height+50)
    }
    
    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
        var totalRect: CGRect = .zero
        
        // 모든 자식 View의 컨트롤의 크기를 재귀적으로 호출하며 최종 영역의 크기를 설정
        for subView in view.subviews {
            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
        }
        
        // 최종 계산 영역의 크기를 반환
        return totalRect.union(view.frame)
    }
}
