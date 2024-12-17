//
//  RangeSlider.swift
//  WHOA_iOS
//
//  Created by KSH on 3/10/24.
//

import UIKit
import SnapKit
import Combine

// 1. touch 영역 정보 - begin/continue/end tracking
// 2. thumb뷰가 터치 되었는지 확인? 위 메소드에서 frame.contains로 확인
// 3. frame.contains로 특정 뷰가 터치 되었는지 확인할것이므로, 각 뷰들을 isUserInteractionEnabled = false 처리 (컨테이너로 있는 UIView만 터치 받도록 처리)
// 4. SnapKit에서 레이아웃 정의할때 .constraint로 Constraint 인스턴스를 가져와서 저장하고있고, continueTracking에서 실시간으로 Constraint의 inset을 변경

// MARK: Constant


final class RangeSlider: UIControl {
    
    // MARK: - Enums
    
    /// Metrics
    private enum Metric {
        static let barRatio = 4.0 / 10.0
        static let minValue = 0.0
        static let maxValue = 100000.0
    }
    
    // MARK: Properties
    
    private var lowerSubject = CurrentValueSubject<Double, Never>(Metric.minValue)
    private var upperSubject = CurrentValueSubject<Double, Never>(Metric.maxValue)
    private var cancellables = Set<AnyCancellable>()
    
    var lowerPublisher: AnyPublisher<Double, Never> {
        lowerSubject.eraseToAnyPublisher()
    }
    
    var upperPublisher: AnyPublisher<Double, Never> {
        upperSubject.eraseToAnyPublisher()
    }
    
    var minValue = Metric.minValue {
        didSet { lowerSubject.send(minValue) }
    }
    
    var maxValue = Metric.maxValue {
        didSet { upperSubject.send(maxValue) }
    }
    
    /// 마지막으로 터치한 지점의 위치
    private var previousTouchPoint = CGPoint.zero
    
    /// LowerThumbView 터치 유무
    private var isLowerThumbViewTouched = false
    
    /// UpperThumbView 터치 유무
    private var isUpperThumbViewTouched = false
    
    /// 왼쪽 핸들의 위치를 조정 값
    private var leftConstraint: Constraint?
    
    /// 오른쪽 핸들의 위치를 조정 값
    private var rightConstraint: Constraint?
    
    /// 핸들의 길이
    private var thumbViewLength: Double {
        Double(self.bounds.height)
    }
    
    // MARK: UI
    
    private let lowerThumbButton: ThumbButton = {
        let button = ThumbButton()
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let upperThumbButton: ThumbButton = {
        let button = ThumbButton()
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let trackView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray03
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let trackTintView: UIView = {
        let view = UIView()
        view.backgroundColor = .second1
        view.isUserInteractionEnabled = false
        return view
    }()
    
    // MARK: Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("xib is not implemented")
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        [
            trackView,
            trackTintView,
            lowerThumbButton,
            upperThumbButton
        ].forEach(addSubview(_:))
        setupAutoLayout()
    }
    
    private func observe() {
        lowerSubject
            .sink { [weak self] newValue in
                self?.updateLayout(newValue, true)
            }
            .store(in: &cancellables)
        
        upperSubject
            .sink { [weak self] newValue in
                self?.updateLayout(newValue, false)
            }
            .store(in: &cancellables)
    }
    
    // MARK: Touch
    
    // 터치 이벤트를 막을지, 실행할지 결정이 가능, frame.contains()를 통해서 특정 뷰를 탭한 경우만 터치 이벤트가 유효하도록 정의
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        return self.lowerThumbButton.frame.contains(point) || self.upperThumbButton.frame.contains(point)
    }
    
    // point메소드에서 true를 반환받은 터치 이벤트가 시작될때 불리는 메서드
    // 터치가 일어나기 시작할때 터치의 위치를 알기 위해서 사용, point와 같이 false나 true를 반환하여 터치 이벤트를 계속할지 결정
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        self.previousTouchPoint = touch.location(in: self)
        self.isLowerThumbViewTouched = self.lowerThumbButton.frame.contains(self.previousTouchPoint)
        self.isUpperThumbViewTouched = self.upperThumbButton.frame.contains(self.previousTouchPoint)
        
        if self.isLowerThumbViewTouched {
            self.lowerThumbButton.isSelected = true
        } else {
            self.upperThumbButton.isSelected = true
        }
        
        return self.isLowerThumbViewTouched || self.isUpperThumbViewTouched
    }
    
    // beginTracking에서 true를 받환받은 터치 이벤트가 불리는 메서드 (드래그 시 계속 호출)
    // 이 메서드에서 오토레이아웃을 통해 계속 뷰의 위치를 업데이트하여 드래그가 되도록 구현
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        let touchPoint = touch.location(in: self)
        defer {
            self.previousTouchPoint = touchPoint
            self.sendActions(for: .valueChanged)
        }
        
        let drag = Double(touchPoint.x - self.previousTouchPoint.x)
        let scale = self.maxValue - self.minValue
        let scaledDrag = scale * drag / Double(self.bounds.width - self.thumbViewLength)
        
        if self.isLowerThumbViewTouched {
            lowerSubject.send((lowerSubject.value + scaledDrag).clamped(to: minValue...upperSubject.value))
        } else if self.isUpperThumbViewTouched {
            upperSubject.send((upperSubject.value + scaledDrag).clamped(to: lowerSubject.value...maxValue))
        }
        return true
    }
    
    // continueTracking에서 true를 반환받은 터치 이벤트가 불리는 메서드 (터치를 마침내 뗀 경우)
    // 해당 메소드에서 isSelected = false와 같은 코드 호출
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        self.sendActions(for: .valueChanged)
        
        self.lowerThumbButton.isSelected = false
        self.upperThumbButton.isSelected = false
    }
    
    // MARK: Functions
    
    private func updateLayout(_ value: Double, _ isLowerThumb: Bool) {
        DispatchQueue.main.async {
            let startValue = value - self.minValue
            let length = self.bounds.width - self.thumbViewLength
            let offset = startValue * length / (self.maxValue - self.minValue)
            
            if isLowerThumb {
                self.leftConstraint?.update(offset: offset)
            } else {
                self.rightConstraint?.update(offset: offset)
            }
        }
    }
    
    func setLowerValue(_ value: Double) {
        lowerSubject.send(value)
    }
    
    func setUpperValue(_ value: Double) {
        upperSubject.send(value)
    }
}

// MARK: - AutoLayout

extension RangeSlider {
    private func setupAutoLayout() {
        lowerThumbButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.right.lessThanOrEqualTo(self.upperThumbButton.snp.left)
            $0.left.greaterThanOrEqualToSuperview()
            $0.width.equalTo(self.snp.height)
            self.leftConstraint = $0.left.equalTo(self.snp.left).priority(999).constraint // .constraint로 값 가져오기 테크닉
        }
        
        upperThumbButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.greaterThanOrEqualTo(self.lowerThumbButton.snp.right)
            $0.right.lessThanOrEqualToSuperview()
            $0.width.equalTo(self.snp.height)
            self.rightConstraint = $0.left.equalTo(self.snp.left).priority(999).constraint
        }
        
        trackView.snp.makeConstraints {
            $0.left.right.centerY.equalToSuperview()
            $0.height.equalTo(self).multipliedBy(Metric.barRatio)
        }
        
        trackTintView.snp.makeConstraints {
            $0.left.equalTo(self.lowerThumbButton.snp.right)
            $0.right.equalTo(self.upperThumbButton.snp.left)
            $0.top.bottom.equalTo(self.trackView)
        }
    }
}

private extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
