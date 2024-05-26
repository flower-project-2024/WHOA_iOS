//
//  ToolTipView.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/17/24.
//

import UIKit
import SnapKit

class ToolTipView: UIView {
    
    // MARK: - Properties
    
    var parentVC: HomeViewController?

    // MARK: - Views

    private let label: HashTagCustomLabel = {
        let label = HashTagCustomLabel(padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        label.font = UIFont(name: "Pretendard-Bold", size: 14)
        label.text = "꽃다발 커스터마이징을 시작해보세요!"
        label.backgroundColor = .primary
        label.textColor = .white
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.image = UIImage.xmarkSmall
        config.baseBackgroundColor = .secondary03
        config.baseForegroundColor = .primary
        config.background.cornerRadius = 22 / 2
        
        button.configuration = config
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private var shape = CAShapeLayer()

    // MARK: - Initialization

    override init (frame: CGRect){
        super.init(frame: .zero)

        self.backgroundColor = .clear

        setLabel()
        setButton()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Layout

    private func setLabel() {
        addSubview(label)

        label.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).inset(11)
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
        }
    }
    
    private func setButton(){
        addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
    }
    
    func drawTip(
        tipStartX: CGFloat,
        tipStartY: CGFloat,
        tipWidth: CGFloat,
        tipHeight: CGFloat) {

        let path = CGMutablePath()

        let tipWidthCenter = tipWidth / 2.0
        let endXWidth = tipStartX + tipWidth

        path.move(to: CGPoint(x: tipStartX, y: tipStartY))
        path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter, y: tipStartY+tipHeight))
        path.addLine(to: CGPoint(x: endXWidth, y: tipStartY))
        path.addLine(to: CGPoint(x: tipStartX, y: tipStartY))

        shape.path = path
        shape.fillColor = UIColor.primary.cgColor

        self.layer.insertSublayer(shape, at: 0)
    }
    
    // MARK: - Actions
    
    @objc func closeButtonDidTap(){
        print("툴팁 닫기 선택됨")
        closeButton.removeFromSuperview()
        label.removeFromSuperview()
        shape.removeFromSuperlayer()
        parentVC?.removeToolTipView()
    }
}
