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
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "어떤 꽃을 찾으시나요?"
        searchBar.searchBarStyle = .minimal
        searchBar.frame.size.width = searchBar.bounds.width
        return searchBar
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    
        view.addSubview(searchBar)
        view.addSubview(todaysFlowerView)
        view.addSubview(cheapFlowerView)
        
        setupNavigation()
        setupConstraints()
        
        todaysFlowerView.decorateButton.addTarget(self, action: #selector(decorateButtonTapped), for: .touchUpInside)

        cheapFlowerView.topThreeTableView.dataSource = self
        cheapFlowerView.topThreeTableView.delegate = self
        
    }

    // MARK: - Helper
    private func setupNavigation(){
        // 내비게이션 바에 로고 이미지
        let logoImageView = UIImageView(image: UIImage(named: "WhoaLogo.png"))
        self.navigationItem.titleView = logoImageView
        
        // 네비게이션 바 줄 없애기
        self.navigationController?.navigationBar.standardAppearance.shadowColor = .white  // 스크롤하지 않는 상태
        self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .white  // 스크롤하고 있는 상태
    }
    
    private func setupConstraints(){
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        todaysFlowerView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(searchBar.snp.horizontalEdges)
        }
        cheapFlowerView.snp.makeConstraints { make in
            make.top.equalTo(todaysFlowerView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(todaysFlowerView.snp.horizontalEdges)
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
        navigationController?.pushViewController(FlowerDetailViewController(), animated: true)
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
