//
//  HomeViewModel.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/6/24.
//

import UIKit

class HomeViewModel {
    
    // MARK: - Properties
    
    private var cheapFlowerRankings: [CheapFlowerModel] = [] {
        didSet {
            cheapFlowerRankingsDidChange?()
        }
    }
    
    private var todaysFlower: TodaysFlowerModel = TodaysFlowerModel() {
        didSet {
            todaysFlowerDidChange?()
        }
    }
    
    var cheapFlowerRankingsDidChange: (() -> Void)?
    var todaysFlowerDidChange: (() -> Void)?
    
    // MARK: - Functions
    
    func fetchCheapFlowerRanking(fromCurrentVC: UIViewController) {
        NetworkManager.shared.fetchCheapFlowerRanking { result in
            switch result {
            case .success(let model):
                self.cheapFlowerRankings = model
            case .failure(let error):
                fromCurrentVC.showAlert(title: "네트워킹 오류", message: error.localizedDescription)
            }
        }
        
    }
    // 저렴한 꽃 1개 리턴 (인덱스에 해당하는)
    func getCheapFlowerModel(index: Int) -> CheapFlowerModel {
        return cheapFlowerRankings[index]
    }
    
    func getCheapFlowerModelCount() -> Int {
        return cheapFlowerRankings.count
    }
    
    /// 입력받은 날짜가 몇 월의 몇 째주인지 계산해주는 함수
    func calculateCheapFlowerBaseDate() -> [String]{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        let date = dateFormatter.date(from: self.cheapFlowerRankings[0].flowerRankingDate) ?? Date()
        
        let calendar = Calendar.current  // 어떤 종류의 달력인지
        let month = calendar.component(.month, from: date)
        let weekNumber = calendar.component(.weekOfMonth, from: date)
        
        if weekNumber == 1 {
            return [String(month), "첫째 주"]
        }
        else if weekNumber == 2 {
            return [String(month), "둘째 주"]
        }
        else if weekNumber == 3 {
            return [String(month), "셋째 주"]
        }
        else {
            return [String(month), "넷째 주"]
        }
    }
    
    func fetchTodaysFlowerModel(_ dateArray: [String], fromCurrentVC: UIViewController) {
        NetworkManager.shared.fetchTodaysFlower(month: dateArray[0], date: dateArray[1], completion: { result in
            switch result {
            case .success(let model):
                self.todaysFlower = model
            case .failure(let error):
                fromCurrentVC.showAlert(title: "네트워킹 오류", message: error.localizedDescription)
            }
        })
    }
    
    func getTodaysFlower() -> TodaysFlowerModel{
        return todaysFlower
    }
    
    func getTodaysFlowerCount() -> Int {
        return 1
    }
}
