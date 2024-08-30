//
//  SavedRequestCell.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/22/24.
//

import UIKit

final class SavedRequestCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "SavedRequestCell"
    
    var requestTitle: String?
    var myPageVC: MyPageViewController?
    var customizingCoordinator: CustomizingCoordinator?
    private var bouquetId: Int?
    
    // MARK: - Views
    
    private let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = UIColor(hex: "F9F9FB")
        return imageView
    }()
    
    private let detailStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        view.alignment = .leading
        return view
    }()
    
    lazy var requestTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Pretendard(size: 18, family: .Bold)
        label.text = "꽃다발 요구서"
        label.textColor = .gray09
        label.numberOfLines = 1
        label.setLineHeight(lineHeight: 140)
        return label
    }()
    
    lazy var writtenDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Pretendard(size: 14, family: .Regular)
        label.text = "2024-01-01"
        label.textColor = .gray09
        label.setLineHeight(lineHeight: 140)
        return label
    }()
    
    private let productionCompleteLabel: UILabel = {
        let label = UILabel()
        label.text = "제작 완료"
        label.textColor = .second3
        label.font = .Pretendard(size: 14, family: .SemiBold)
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var modifyButton: RequestCustomButton = {
        let button = RequestCustomButton(title: "수정")
        button.addTarget(self, action: #selector(modifyBtnTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: RequestCustomButton = {
        let button = RequestCustomButton(title: "삭제")
        button.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        contentView.layer.cornerRadius = 10
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.gray03.cgColor
//        contentView.layer.masksToBounds = true
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    }
    
    // MARK: - Functions
    
    private func addViews() {
        contentView.addSubview(flowerImageView)
        contentView.addSubview(detailStackView)
        contentView.addSubview(productionCompleteLabel)
        contentView.addSubview(buttonStackView)
        
        detailStackView.addArrangedSubview(requestTitleLabel)
        detailStackView.addArrangedSubview(writtenDateLabel)
//        detailStackView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(modifyButton)
        buttonStackView.addArrangedSubview(deleteButton)
    }
    
    private func setupConstraints() {
        flowerImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(24)
            make.height.equalTo(204)
            make.width.equalTo(flowerImageView.snp.height).multipliedBy(4.0 / 5.0)
        }
        
        detailStackView.snp.makeConstraints { make in
            make.top.equalTo(flowerImageView.snp.top).inset(9.5)
            make.leading.equalTo(flowerImageView.snp.trailing).offset(26)
            make.trailing.equalToSuperview().inset(17)
        }
        
        productionCompleteLabel.snp.makeConstraints { make in
            make.leading.equalTo(detailStackView.snp.leading)
            make.top.equalTo(detailStackView.snp.bottom).offset(14)
        }
        
//        requestTitleLabel.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(20)
//            make.trailing.greaterThanOrEqualToSuperview().inset(20)
//            make.top.equalToSuperview().inset(27)
//        }
//        
//        writtenDateLabel.snp.makeConstraints { make in
//            make.leading.equalTo(requestTitleLabel.snp.leading)
//            make.top.equalTo(requestTitleLabel.snp.bottom).offset(6)
//        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalTo(flowerImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
            make.top.equalTo(productionCompleteLabel.snp.bottom).offset(69)
            make.bottom.equalTo(flowerImageView.snp.bottom).inset(9.5)
        }
    }
    
    func configure(model: BouquetModel) {
        self.requestTitle = model.bouquetTitle
        print(requestTitleLabel.text)
        
        requestTitleLabel.text = model.bouquetTitle
        print(requestTitleLabel.text)

        bouquetId = model.bouquetId
        writtenDateLabel.text = model.bouquetCreatedAt.replacingOccurrences(of: "-", with: ".")
        
        if !model.bouquetImgPaths.isEmpty {
            if let url = URL(string: model.bouquetImgPaths[0]) {
                ImageProvider.shared.setImage(into: flowerImageView, from: url.absoluteString)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func modifyBtnTapped() {
        let customAlertVC = CustomAlertViewController(requestTitle: requestTitle, alertType: .modify, currentVC: myPageVC!)
        customAlertVC.bouquetId = bouquetId
        customAlertVC.customizingCoordinator = customizingCoordinator
        customAlertVC.modalPresentationStyle = .overFullScreen
        myPageVC?.present(customAlertVC, animated: false, completion: nil)
    }
    
    @objc func deleteBtnTapped() {
        let customAlertVC = CustomAlertViewController(requestTitle: requestTitle, alertType: .delete, currentVC: myPageVC!)
        customAlertVC.bouquetId = bouquetId
        customAlertVC.delegate = myPageVC
        
        customAlertVC.modalPresentationStyle = .overFullScreen
        myPageVC?.present(customAlertVC, animated: false, completion: nil)
    }
}
