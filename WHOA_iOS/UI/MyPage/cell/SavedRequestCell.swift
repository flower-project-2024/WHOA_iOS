//
//  SavedRequestCell.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 2/22/24.
//

import UIKit

class SavedRequestCell: UITableViewCell {
    
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
        return imageView
    }()
    
    private let detailView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray02
        return view
    }()
    
    lazy var requestTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Pretendard(size: 16, family: .Medium)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var writtenDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Pretendard(size: 14, family: .Regular)
        label.text = "2024-01-01"
        label.textColor = UIColor(red: 144/255, green: 144/255, blue: 144/255, alpha: 1)
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
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
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray03.cgColor
        contentView.layer.masksToBounds = true
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
    
    // MARK: - Helpers
    
    private func addViews(){
        contentView.addSubview(flowerImageView)
        contentView.addSubview(detailView)
        
        detailView.addSubview(requestTitleLabel)
        detailView.addSubview(writtenDateLabel)
        detailView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(modifyButton)
        buttonStackView.addArrangedSubview(deleteButton)
    }
    
    private func setupConstraints(){
        flowerImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.height.equalTo(160)
            make.width.equalTo(flowerImageView.snp.height).multipliedBy(7.0 / 8.0)
        }
        
        detailView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalTo(flowerImageView.snp.trailing)
        }
        
        requestTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.greaterThanOrEqualToSuperview().inset(20)
            make.top.equalToSuperview().inset(27)
        }
        
        writtenDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(requestTitleLabel.snp.leading)
            make.top.equalTo(requestTitleLabel.snp.bottom).offset(6)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalTo(writtenDateLabel.snp.leading)
            make.top.equalTo(writtenDateLabel.snp.bottom).offset(34)
        }
    }
    
    func configure(model: BouquetModel){
        self.requestTitle = model.bouquetTitle
        
        requestTitleLabel.text = model.bouquetTitle
        bouquetId = model.bouquetId
        writtenDateLabel.text = model.bouquetCreatedAt.replacingOccurrences(of: "-", with: ".")
        
        if !model.bouquetImgPaths.isEmpty {
            if let url = URL(string: model.bouquetImgPaths[0]) {
                ImageProvider.shared.setImage(into: flowerImageView, from: url.absoluteString)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func modifyBtnTapped(){
        let customAlertVC = CustomAlertViewController(requestTitle: requestTitle, alertType: .modify, currentVC: myPageVC!)
        customAlertVC.bouquetId = bouquetId
        customAlertVC.customizingCoordinator = customizingCoordinator
        customAlertVC.modalPresentationStyle = .overFullScreen
        myPageVC?.present(customAlertVC, animated: false, completion: nil)
    }
    
    @objc func deleteBtnTapped(){
        let customAlertVC = CustomAlertViewController(requestTitle: requestTitle, alertType: .delete, currentVC: myPageVC!)
        customAlertVC.bouquetId = bouquetId
        customAlertVC.delegate = myPageVC
        
        customAlertVC.modalPresentationStyle = .overFullScreen
        myPageVC?.present(customAlertVC, animated: false, completion: nil)
    }
}
