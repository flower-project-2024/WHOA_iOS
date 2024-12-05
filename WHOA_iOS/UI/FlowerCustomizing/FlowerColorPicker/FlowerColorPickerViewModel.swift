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
        let initialHexColor: AnyPublisher<[String], Never>
        let dismissView: AnyPublisher<Void, Never>
        let showFlowerSelection: AnyPublisher<Void, Never>
        let isNextButtonEnabled: AnyPublisher<Bool, Never>
    }
    
    private let dataManager: BouquetDataManaging
    private let isCustomV2: Bool
    private var customV2HexColor: String?
    private let colorTypeSubject = CurrentValueSubject<NumberOfColorsType, Never>(.none)
    private let hexColorsSubject = CurrentValueSubject<[String], Never>([])
    private let resultButtonIndexSubject = CurrentValueSubject<Int, Never>(0)
    private let dismissSubject = PassthroughSubject<Void, Never>()
    private let showFlowerSelectionSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = BouquetDataManager.shared) {
        self.dataManager = dataManager
        self.isCustomV2 = dataManager.getActionType() == .customV2
        initColorScheme(colorScheme: dataManager.getColorScheme())
    }
    
    // MARK: - Functions
    
    func transform(input: Input) -> Output {
        input.colorTypeSelected
            .dropFirst()
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
                guard let self = self else { return }
                let colorType = self.colorTypeSubject.value
                let colorScheme = createColorScheme(for: colorType)
                self.dataManager.setColorScheme(colorScheme)
                self.showFlowerSelectionSubject.send()
            }
            .store(in: &cancellables)
        
        let isNextButtonEnabled = hexColorsSubject
            .map { hexColors in
                return !hexColors.contains("") && !hexColors.isEmpty
            }
            .removeDuplicates()
        
        return Output(
            initialColorType: colorTypeSubject.eraseToAnyPublisher(),
            initialHexColor: hexColorsSubject.eraseToAnyPublisher(),
            dismissView: dismissSubject.eraseToAnyPublisher(),
            showFlowerSelection: showFlowerSelectionSubject.eraseToAnyPublisher(),
            isNextButtonEnabled: isNextButtonEnabled.eraseToAnyPublisher()
        )
    }
    
    private func updateHexColorsArray(for colorType: NumberOfColorsType) {
        let firstColor = customV2HexColor ?? ""
        
        switch colorType {
        case .oneColor:
            hexColorsSubject.send([firstColor])
        case .twoColor, .pointColor:
            hexColorsSubject.send([firstColor, ""])
        case .colorful:
            hexColorsSubject.send([firstColor, "", ""])
        default:
            hexColorsSubject.send([firstColor])
        }
    }
    
    private func addHexColor(_ hexColor: String, _ resultButtonIndex: Int) {
        guard !(isCustomV2 && resultButtonIndex == 0) else { return }
        var hexColors = hexColorsSubject.value
        hexColors[resultButtonIndex] = hexColor
        hexColorsSubject.send(hexColors)
    }
    
    private func initColorScheme(colorScheme: BouquetData.ColorScheme) {
        var colors = colorScheme.colors
        
        if let pointColor = colorScheme.pointColor {
            colors.insert(pointColor, at: 0)
        }
        
        if isCustomV2 {
            customV2HexColor = colors.first
        }
        
        colorTypeSubject.send(colorScheme.numberOfColors)
        hexColorsSubject.send(colors)
    }
    
    private func createColorScheme(for colorType: NumberOfColorsType) -> BouquetData.ColorScheme {
        let colors = hexColorsSubject.value
        let pointColor = colorType == .pointColor ? colors.first : nil
        let filteredColors = colorType == .pointColor ? Array(colors.dropFirst()) : colors
        
        return BouquetData.ColorScheme(
            numberOfColors: colorType,
            pointColor: pointColor,
            colors: filteredColors
        )
    }
}
