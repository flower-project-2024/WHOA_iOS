//
//  MoreActionsSheetViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 9/1/24.
//

import UIKit
import SnapKit

final class MoreActionsSheetViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: RequestDetailViewModel
    private let isProducted: Bool
    private let bouquetData: BouquetData
    private var requestDetailVC: RequestDetailViewController
    static private var hasBezel: Bool {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let firstWindow = windowScene?.windows.first
        return firstWindow?.safeAreaInsets.bottom ?? 0 > 0  // true면 베젤이 있음, false면 베젤 없음(=se)
    }
    
    weak var delegate: CustomAlertViewControllerDelegate?
    weak var bouquetProductionSuccessDelegate: BouquetProductionSuccessDelegate?
    
    // MARK: - Views
    
    private let menuStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12.adjustedH()
        return view
    }()
    
    private let productionCompletedOrGalleryButton: MoreActionCustomButton = {
        let button = MoreActionCustomButton(hasBezel: hasBezel,
                                            title: "꽃다발 제작 완료",
                                            subtitle: "해당 요구서로 꽃다발을 만들었다면 제작 완료 버튼을 눌러주세요")
        button.addTarget(self, action: #selector(changeBouquetStatusToProducted), for: .touchUpInside)
        return button
    }()
    
    private let modifyButton: MoreActionCustomButton = {
        let button = MoreActionCustomButton(hasBezel: hasBezel,
                                            title: "수정하기",
                                            subtitle: nil)
        button.addTarget(self, action: #selector(modifyButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let deleteButton: MoreActionCustomButton = {
        let button = MoreActionCustomButton(hasBezel: hasBezel,
                                            title: "삭제하기",
                                            subtitle: nil)
        button.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.title = "취소"
        config.attributedTitle?.font = .Pretendard(size: 16, family: .SemiBold)
        config.background.backgroundColor = UIColor.customPrimary
        config.background.cornerRadius = 10
        config.contentInsets = .init(top: 17.adjustedH(), 
                                     leading: 15.adjusted(),
                                     bottom: 17.adjustedH(),
                                     trailing: 15.adjusted())
        config.baseForegroundColor = .gray02
        button.configuration = config
        
        button.addAction(
            UIAction(handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }),
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: - Init
    
    init(title: String,
         bouquetId: Int,
         isProducted: Bool,
         bouquetData: BouquetData,
         from currentVC: RequestDetailViewController
    ) {
        viewModel = RequestDetailViewModel(requestTitle: title, bouquetId: bouquetId)
        self.isProducted = isProducted
        self.bouquetData = bouquetData
        requestDetailVC = currentVC
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configFirstButton()
        addViews()
        setupConstraints()
        bind()
    }
    
    // MARK: - Actions
    
    @objc private func changeBouquetStatusToProducted() {
        if isProducted {
            dismiss(animated: true)
            bouquetProductionSuccessDelegate?.didSelectGoToGallery()
        }
        else {
            viewModel.patchBouquetStatus()
        }
    }
    
    @objc private func modifyButtonDidTap() {
        let id = viewModel.getBouquetId()
        fetchBouquetDetail(requestTitle: viewModel.getRequestTitle(), bouquetId: id)
        dismiss(animated: true) { [weak self] in
            BouquetDataManager.shared.setActionType(.update(bouquetId: id))
            self?.requestDetailVC.myPageVC?.customizingCoordinator?.showPurposeVC()
            self?.requestDetailVC.myPageVC?.tabBarController?.selectedIndex = 1
        }
    }
    
    @objc private func deleteButtonDidTap() {
        viewModel.deleteBouquet()
    }
    
    // MARK: - Functions
    
    private func addViews() {
        view.addSubview(menuStackView)
        menuStackView.addArrangedSubview(productionCompletedOrGalleryButton)
        menuStackView.addArrangedSubview(modifyButton)
        menuStackView.addArrangedSubview(deleteButton)
        
        view.addSubview(cancelButton)
    }
    
    private func setupConstraints() {
        menuStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(50.adjustedH())
            make.leading.trailing.equalToSuperview().inset(20.adjusted())
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(menuStackView.snp.bottom).offset(37.adjustedH())
            make.leading.trailing.equalToSuperview().inset(18.adjusted())
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8.adjustedH())
        }
    }
    
    private func bind() {
        viewModel.bouquetStatusDidChange = { [weak self] statusDidChange in
            guard let statusDidChange = statusDidChange else { return }
            
            if statusDidChange {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                    self?.requestDetailVC.showProductionSuccessAlert()
                }
            }
        }
        
        viewModel.deleteSuccessDidChange = { [weak self] _ in
            guard let bouquetId = self?.viewModel.getBouquetId() else { return }
            DispatchQueue.main.async {
                self?.dismiss(animated: false) {
                    self?.delegate?.deleteSuccessful(bouquetId: bouquetId)
                    self?.requestDetailVC.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        viewModel.showError = { [weak self] error in
            self?.showAlert(title: "네트워킹 오류", message: error.localizedDescription)
        }
    }
    
    /// 이미 제작완료된 경우 맨 위 버튼은 제작 완료 -> 사진 변경하기로 바꿔야 함
    private func configFirstButton() {
        if isProducted {
            productionCompletedOrGalleryButton.changeTitleAndSubtitle(title: "꽃다발 사진 변경하기",
                                                                      subtitle: "")
        }
    }
    
    func fetchBouquetDetail(requestTitle: String, bouquetId: Int) {
        guard let id = KeychainManager.shared.loadMemberId() else { return }
        NetworkManager.shared.fetchBouquetDetail(memberID: id, bouquetId: bouquetId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let dto):
                BouquetDetailDTO.saveBouquetData(
                    requestTitle: requestTitle,
                    dto: dto,
                    dataManager: BouquetDataManager.shared
                )
            case .failure(let error):
                self.showAlert(title: "네트워킹 오류", message: error.localizedDescription)
            }
        }
    }
}
