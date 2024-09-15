//
//  FlowerColorPickerViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import Foundation
import Combine

final class FlowerColorPickerViewModel: ViewModel {
    
    // MARK: - Properties
    
    struct Input {
        let colorTypeSelected: AnyPublisher<NumberOfColorsType, Never>
        let hexColorSelected: AnyPublisher<String, Never>
        let resultButtonIndex: AnyPublisher<Int, Never>
        let backButtonTapped: AnyPublisher<Void, Never>
        let nextButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let initialColorType: AnyPublisher<NumberOfColorsType, Never>
        let initialHexColor: AnyPublisher<String, Never>
        let dismissView: AnyPublisher<Void, Never>
        let showFlowerSelection: AnyPublisher<Void, Never>
    }
    
    private let dataManager: BouquetDataManaging
    private let colorTypeSubject = CurrentValueSubject<NumberOfColorsType, Never>(.none)
    private let hexColorsSubject = CurrentValueSubject<[String], Never>([])
    private let resultButtonIndexSubject = CurrentValueSubject<Int, Never>(0)
    private let dismissSubject = PassthroughSubject<Void, Never>()
    private let showFlowerSelectionSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = BouquetDataManager.shared) {
        self.dataManager = dataManager
    }
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        
        input.colorTypeSelected
            .sink { [weak self] colorType in
                self?.colorTypeSubject.send(colorType)
                self?.updateHexColorsArray(for: colorType)
            }
            .store(in: &cancellables)
        
        input.hexColorSelected
            .sink { [weak self] hexColor in
                guard let self = self else { return }
                self.addHexColor(hexColor, self.resultButtonIndexSubject.value)
            }
            .store(in: &cancellables)
        
        input.resultButtonIndex
            .assign(to: \.value, on: resultButtonIndexSubject)
            .store(in: &cancellables)
        
        input.backButtonTapped
            .sink { [weak self] _ in
                self?.dismissSubject.send()
            }
            .store(in: &cancellables)
        
        input.nextButtonTapped
            .sink { [weak self] _ in
                // DataManager Data 전달 로직 추가 필요
                self?.showFlowerSelectionSubject.send()
            }
            .store(in: &cancellables)
        
        return Output(
            initialColorType: colorTypeSubject.eraseToAnyPublisher(),
            initialHexColor: input.hexColorSelected.eraseToAnyPublisher(),
            dismissView: dismissSubject.eraseToAnyPublisher(),
            showFlowerSelection: showFlowerSelectionSubject.eraseToAnyPublisher()
        )
    }
    
    private func updateHexColorsArray(for colorType: NumberOfColorsType) {
        switch colorType {
        case .oneColor:
            hexColorsSubject.send([""])
        case .twoColor, .pointColor:
            hexColorsSubject.send(["", ""])
        case .colorful:
            hexColorsSubject.send(["", "", ""])
        default:
            hexColorsSubject.send([""])
        }
    }
    
    private func addHexColor(_ hexColor: String, _ resultButtonIndex: Int) {
        var hexColors = hexColorsSubject.value
        let colorType = colorTypeSubject.value
        hexColors[resultButtonIndex] = hexColor
        hexColorsSubject.send(hexColors)
    }
}
