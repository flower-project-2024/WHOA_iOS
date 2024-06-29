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
    
    func fetchCheapFlowerRanking(fromCurrentVC: UIViewController){
        NetworkManager.shared.fetchCheapFlowerRanking { result in
            switch result {
            case .success(let model):
                self.cheapFlowerRankings = model
            case .failure(let error):
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async { [unowned self] in
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
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
    
    func fetchTodaysFlowerModel(_ dateArray: [String], fromCurrentVC: UIViewController) {
        NetworkManager.shared.fetchTodaysFlower(month: dateArray[0], date: dateArray[1], completion: { result in
            switch result {
            case .success(let model):
                self.todaysFlower = model
            case .failure(let error):
                let networkAlertController = self.networkErrorAlert(error)

                DispatchQueue.main.async { [unowned self] in
                    fromCurrentVC.present(networkAlertController, animated: true)
                }
            }
        })
    }
    
    func getTodaysFlower() -> TodaysFlowerModel{
        return todaysFlower
    }
    
    func getTodaysFlowerCount() -> Int {
        return 1
    }
    
    private func networkErrorAlert(_ error: Error) -> UIAlertController{
        let alertController = UIAlertController(title: "네트워크 에러가 발생했습니다.", message: error.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        
        return alertController
    }
}
