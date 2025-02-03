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
        let todaysFlowerButtonTapped: AnyPublisher<Void, Never>
        let customizeIntroTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let fetchTodaysFlower: AnyPublisher<TodaysFlowerModel?, Never>
        let fetchCheapFlowerRankings: AnyPublisher<[CheapFlowerModel], Never>
        let fetchPopularFlowerRankings: AnyPublisher<[popularityData], Never>
        let cheapFlowerRankingDate: AnyPublisher<String, Never>
        let errorMessage: AnyPublisher<String, Never>
        let showFlowerDetailView: AnyPublisher<Int, Never>
        let showCustomizingView: AnyPublisher<Void, Never>
    }
    
    private let networkManager: NetworkManager
    private let todaysFlowerSubject = CurrentValueSubject<TodaysFlowerModel?, Never>(nil)
    private let cheapFlowerRankingsSubject = PassthroughSubject<[CheapFlowerModel], Never>()
    private let cheapFlowerRankingDateSubject = PassthroughSubject<String, Never>()
    private let popularFlowerRankingsSubject = PassthroughSubject<[popularityData], Never>()
    private let errorMessageSubject = PassthroughSubject<String, Never>()
    private let showFlowerDetailViewSubject = PassthroughSubject<Int, Never>()
    private let showCustomzingViewSubject = PassthroughSubject<Void, Never>()
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
                self?.fetchPopularityFlowerRanking()
            }
            .store(in: &cancellables)
        
        input.todaysFlowerButtonTapped
            .sink { [weak self] _ in
                guard let flowerId = self?.todaysFlowerSubject.value?.flowerId else { return }
                self?.showFlowerDetailViewSubject.send(flowerId)
            }
            .store(in: &cancellables)
        
        input.customizeIntroTapped
            .sink { [weak self] _ in
                self?.showCustomzingViewSubject.send()
            }
            .store(in: &cancellables)
        
        return Output(
            fetchTodaysFlower: todaysFlowerSubject.eraseToAnyPublisher(),
            fetchCheapFlowerRankings: cheapFlowerRankingsSubject.eraseToAnyPublisher(),
            fetchPopularFlowerRankings: popularFlowerRankingsSubject.eraseToAnyPublisher(),
            cheapFlowerRankingDate: cheapFlowerRankingDateSubject.eraseToAnyPublisher(),
            errorMessage: errorMessageSubject.eraseToAnyPublisher(),
            showFlowerDetailView: showFlowerDetailViewSubject.eraseToAnyPublisher(),
            showCustomizingView: showCustomzingViewSubject.eraseToAnyPublisher()
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
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.cheapFlowerRankingsSubject.send(model)
                
                if let firstDateString = model.first?.flowerRankingDate {
                    let formattedDate = self.formatRankingDate(from: firstDateString)
                    self.cheapFlowerRankingDateSubject.send(formattedDate)
                }
            case .failure(let error):
                self.errorMessageSubject.send(error.localizedDescription)
            }
        }
    }
    
    private func fetchPopularityFlowerRanking() {
        networkManager.fetchPopularityFlowerRanking { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                let popularData = Array(model.prefix(3))
                self.popularFlowerRankingsSubject.send(popularData)
            case .failure(let error):
                self.errorMessageSubject.send(error.localizedDescription)
            }
        }
    }
    
    private func formatRankingDate(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else {
            return dateString
        }
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let weekOfMonth = calendar.component(.weekOfMonth, from: date)
        
        let ordinalWeek: String
        switch weekOfMonth {
        case 1:
            ordinalWeek = "첫째"
        case 2:
            ordinalWeek = "둘째"
        case 3:
            ordinalWeek = "셋째"
        case 4:
            ordinalWeek = "넷째"
        case 5:
            ordinalWeek = "다섯째"
        default:
            ordinalWeek = "\(weekOfMonth)째"
        }
        
        return "\(month)월 \(ordinalWeek) 주 기준\n출처: 화훼유통정보시스템"
    }
}
