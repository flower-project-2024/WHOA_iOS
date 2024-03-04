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
    
    // MARK: - Views
    private let flowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        //imageView.layer.masksToBounds = true
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    private let detailView: UIView = {
        let view = UIView()
        //view.clipsToBounds = true
        view.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 251/255, alpha: 1) // gray02
        return view
    }()
    
    lazy var requestTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 16)
        //label.text = requestTitle
        label.numberOfLines = 1
        return label
    }()
    
    lazy var writtenDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.text = "2024-01-01"
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var modifyButton: RequestCustomButton = {
        let button = RequestCustomButton(title: "수정")
        //button.configuration?.attributedTitle = AttributedString.init("수정")
        //button.setTitle("수정", for: .normal)
        button.addTarget(self, action: #selector(modifyBtnTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteButton: RequestCustomButton = {
        let button = RequestCustomButton(title: "삭제")
        //button.configuration?.title = "삭제"
        //button.setTitle("삭제", for: .normal)
        button.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = CGColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1) //gray03
        contentView.layer.masksToBounds = true
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    }
    
    // MARK: - Helpers
    
    private func addViews(){
        contentView.addSubview(flowerImageView)
        contentView.addSubview(detailView)
        
        detailView.addSubview(requestTitleLabel)
        detailView.addSubview(writtenDateLabel)
//        detailView.addSubview(modifyButton)
//        detailView.addSubview(deleteButton)
        detailView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(modifyButton)
        buttonStackView.addArrangedSubview(deleteButton)
    }
    
    private func setupConstraints(){
        flowerImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(flowerImageView.snp.height).multipliedBy(4.0 / 5.0)
        }
        
        detailView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalTo(flowerImageView.snp.trailing)
        }
        
        requestTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.greaterThanOrEqualToSuperview().inset(50)  // ????
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
    
    func setTitle(title: String){
        self.requestTitle = title
        
        // title label 텍스트 설정
        requestTitleLabel.text = title
    }
    
    // MARK: - Actions
    @objc func modifyBtnTapped(){
        print("===요구서 수정===")
    }
    
    @objc func deleteBtnTapped(){
        print("===요구서 삭제===")
        let customAlertVC = CustomAlertViewController(requestTitle: requestTitle)
        
        customAlertVC.modalPresentationStyle = .overFullScreen
        myPageVC?.present(customAlertVC, animated: false, completion: nil)
    }
}
