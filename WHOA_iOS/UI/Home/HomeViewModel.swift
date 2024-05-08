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
    
    func fetchCheapFlowerRanking(){
        NetworkManager.shared.fetchCheapFlowerRanking { result in
            switch result {
            case .success(let model):
                self.cheapFlowerRankings = model
            case .failure(let error):
                print("저렴한 꽃 랭킹 조회 실패")
                //                let networkAlertController = self.networkErrorAlert(error)
                //
                //                DispatchQueue.main.async { [unowned self] in
                //                    fromCurrentVC.present(networkAlertController, animated: true)
                //                }
            }
        }
    }
    
    // 저렴한 꽃 1개 리턴 (인덱스에 해당하는)
    func getCheapFlowerModel(index: Int) -> CheapFlowerModel {
        print(cheapFlowerRankings)
        return cheapFlowerRankings[index]
    }
    
    func getCheapFlowerModelCount() -> Int {
        return cheapFlowerRankings.count
    }
    
    func fetchTodaysFlowerModel(month: Int, date: Int) {
        NetworkManager.shared.fetchTodaysFlower(month: month, date: date, completion: { result in
            switch result {
            case .success(let model):
                self.todaysFlower = model
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func getTodaysFlower() -> TodaysFlowerModel{
        print(todaysFlower)
        return todaysFlower
    }
    
    func getTodaysFlowerCount() -> Int {
        return 1
    }
}
