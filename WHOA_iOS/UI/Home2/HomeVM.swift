//
//  HomeVM.swift
//  WHOA_iOS
//
//  Created by 김세훈 on 1/15/25.
//

import UIKit
import Combine

final class HomeVM: ViewModel {
    
    // MARK: - Properties
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let fetchTodaysFlower: AnyPublisher<TodaysFlowerModel, Never>
        let fetchCheapFlowerRankings: AnyPublisher<[CheapFlowerModel], Never>
        let errorMessage: AnyPublisher<String, Never>
    }
    
    private let networkManager: NetworkManager
    private let todaysFlowerSubject = PassthroughSubject<TodaysFlowerModel, Never>()
    private let cheapFlowerRankingsSubject = PassthroughSubject<[CheapFlowerModel], Never>()
    private let errorMessageSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        input.viewDidLoad
            .sink { [weak self] _ in
                self?.fetchTodaysFlower()
                self?.fetchCheapFlowerRankings()
            }
            .store(in: &cancellables)
        
        return Output(
            fetchTodaysFlower: todaysFlowerSubject.eraseToAnyPublisher(),
            fetchCheapFlowerRankings: cheapFlowerRankingsSubject.eraseToAnyPublisher(),
            errorMessage: errorMessageSubject.eraseToAnyPublisher()
        )
    }
    
    private func fetchTodaysFlower() {
        let currentDate = Date()
        let calendar = Calendar.current
        let month = String(calendar.component(.month, from: currentDate))
        let day = String(calendar.component(.day, from: currentDate))
        
        networkManager.fetchTodaysFlower(month: month, date: day) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let flowerModel):
                self.todaysFlowerSubject.send(flowerModel)
            case .failure(let error):
                self.errorMessageSubject.send(error.localizedDescription)
            }
        }
    }
    
    private func fetchCheapFlowerRankings() {
        networkManager.fetchCheapFlowerRanking { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                self.cheapFlowerRankingsSubject.send(model)
            case .failure(let error):
                self.errorMessageSubject.send(error.localizedDescription)
            }
        }
    }
}
