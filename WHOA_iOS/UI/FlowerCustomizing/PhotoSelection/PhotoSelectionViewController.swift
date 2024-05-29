//
//  PhotoSelectionViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 3/11/24.
//

import UIKit
import Photos

class PhotoSelectionViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: PhotoSelectionViewModel
    weak var coordinator: CustomizingCoordinator?
    
    // MARK: - UI
    
    private let exitButton = ExitButton()
    private let progressHStackView = CustomProgressHStackView(numerator: 6, denominator: 7)
    private let titleLabel = CustomTitleLabel(text: "추가로 사장님께\n요구할 사항들을 작성해주세요")
    
    private let requirementLabel: UILabel = {
        let label = UILabel()
        label.text = "요구사항"
        label.textColor = .black
        label.font = .Pretendard(size: 16, family: .SemiBold)
        return label
    }()
    
    private let requirementTextView: UITextView = {
        let view = UITextView()
        view.font = .Pretendard()
        view.textColor = .black
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray6.cgColor
        view.textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        return view
    }()
    
    private let placeholder: UILabel = {
        let label = UILabel()
        label.text = "요구사항을 작성해주세요."
        label.textColor = .gray6
        label.font = .Pretendard()
        return label
    }()
    
    private let photoLabel: UILabel = {
        let label = UILabel()
        label.text = "참고 사진"
        label.textColor = .black
        label.font = .Pretendard(size: 16, family: .SemiBold)
        return label
    }()
    
    private lazy var addImageButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus.circle")
        imageView.tintColor = .black
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(photoImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let photoImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PhotoIcon")
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray2
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var minusImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MinusButton")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.tag = 1
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(minusImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let photoImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PhotoIcon")
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray2
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var minusImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MinusButton")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.tag = 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(minusImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let photoImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PhotoIcon")
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray2
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var minusImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MinusButton")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.tag = 3
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(minusImageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var photoImageViewHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            addImageButton,
            photoImageView1,
            photoImageView2,
            photoImageView3
        ].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private let photoImageHScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let borderLine = ShadowBorderLine()
    
    private let backButton: UIButton = {
        let button = BackButton(isActive: true)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = NextButton()
        button.isActive = true
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var navigationHStackView: UIStackView = {
        let stackView = UIStackView()
        [
            backButton,
            nextButton
        ].forEach { stackView.addArrangedSubview($0) }
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 9
        return stackView
    }()
    
    // MARK: - Initialize
    
    init(viewModel: PhotoSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(exitButton)
        view.addSubview(progressHStackView)
        view.addSubview(titleLabel)
        
        view.addSubview(requirementLabel)
        view.addSubview(requirementTextView)
        view.addSubview(placeholder)
        view.addSubview(photoLabel)
        view.addSubview(photoImageHScrollView)
        photoImageHScrollView.addSubview(photoImageViewHStackView)
        
        photoImageView1.addSubview(minusImageView1)
        photoImageView2.addSubview(minusImageView2)
        photoImageView3.addSubview(minusImageView3)
        
        view.addSubview(borderLine)
        view.addSubview(navigationHStackView)
        
        setupAutoLayout()
        requirementTextView.delegate = self
    }
    
    private func resetImageViews() {
        photoImageView1.image = UIImage(named: "PhotoIcon")
        photoImageView2.image = UIImage(named: "PhotoIcon")
        photoImageView3.image = UIImage(named: "PhotoIcon")
        photoImageView1.contentMode = .center
        photoImageView2.contentMode = .center
        photoImageView3.contentMode = .center
    }
    
    private func updateImageViews(with photos: [UIImage?]) {
      for (index, image) in photos.enumerated() {
        switch index {
        case 0:
          photoImageView1.image = image
          photoImageView1.contentMode = .scaleAspectFill
        case 1:
          photoImageView2.image = image
          photoImageView2.contentMode = .scaleAspectFill
        case 2:
          photoImageView3.image = image
          photoImageView3.contentMode = .scaleAspectFill
        default:
          break
        }
      }
    }
    private func updateMinusImageViews() {
        minusImageView1.isHidden = photoImageView1.image == UIImage(named: "PhotoIcon")
        minusImageView2.isHidden = photoImageView2.image == UIImage(named: "PhotoIcon")
        minusImageView3.isHidden = photoImageView3.image == UIImage(named: "PhotoIcon")
    }
    
    // MARK: - Actions
    
    @objc
    func minusImageViewTapped(_ sender: UITapGestureRecognizer) {
        let idx = sender.view?.tag == 1 ? 0 : sender.view?.tag == 2 ? 1 : 2
        
        viewModel.photos.remove(at: idx)
        resetImageViews()
        updateImageViews(with: viewModel.getPhotosArray())
        updateMinusImageViews()
    }
    
    @objc
    func photoImageViewTapped() {
        viewModel.authService.requestAuthorization { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                let vc = PhotoViewController(photosCount: viewModel.getPhotosCount())
                vc.modalPresentationStyle = .fullScreen
                vc.completionHandler = { photos in
                    self.viewModel.addPhotos(photos: photos.values.map{ $0 })
                    
                    for i in 0..<self.viewModel.getPhotosCount() {
                        switch i {
                        case 0:
                            self.photoImageView1.image = self.viewModel.getPhoto(idx: i)
                            self.photoImageView1.contentMode = .scaleAspectFill
                            self.minusImageView1.isHidden = false
                        case 1:
                            self.photoImageView2.image = self.viewModel.getPhoto(idx: i)
                            self.photoImageView2.contentMode = .scaleAspectFill
                            self.minusImageView2.isHidden = false
                        case 2:
                            self.photoImageView3.image = self.viewModel.getPhoto(idx: i)
                            self.photoImageView3.contentMode = .scaleAspectFill
                            self.minusImageView3.isHidden = false
                        default:
                            continue
                        }
                    }
                    
                    switch self.viewModel.getPhotosCount() {
                    case 1:
                        self.photoImageView3.image = UIImage(named: "PhotoIcon")
                        self.photoImageView3.contentMode = .center
                    case 0:
                        self.photoImageView3.image = UIImage(named: "PhotoIcon")
                        self.photoImageView2.image = UIImage(named: "PhotoIcon")
                        self.photoImageView3.contentMode = .center
                        self.photoImageView2.contentMode = .center
                    default:
                        break
                    }
                }
                
                present(vc, animated: true)
                
            case .failure:
                return
            }
        }
    }
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func nextButtonTapped() {
        viewModel.convertPhotosToBase64()
        self.viewModel.photosBase64Strings
        
        coordinator?.showCustomizingSummaryVC()
    }
}

extension PhotoSelectionViewController {
    private func setupAutoLayout() {
        exitButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(17)
            $0.leading.equalToSuperview().offset(22)
        }
        
        progressHStackView.snp.makeConstraints {
            $0.top.equalTo(exitButton.snp.bottom).offset(29)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(19.5)
            $0.height.equalTo(12.75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressHStackView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        requirementLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(280)
        }
        
        requirementTextView.snp.makeConstraints {
            $0.top.equalTo(requirementLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(120)
        }
        
        placeholder.snp.makeConstraints {
            $0.top.leading.equalTo(requirementTextView).offset(20)
        }
        
        photoLabel.snp.makeConstraints {
            $0.top.equalTo(requirementTextView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(280)
        }
        
        photoImageView1.snp.makeConstraints {
            $0.width.equalTo(130)
            $0.height.equalTo(136)
        }
        
        photoImageViewHStackView.snp.makeConstraints {
            $0.edges.equalTo(photoImageHScrollView)
            $0.height.equalTo(photoImageHScrollView)
        }
        
        photoImageHScrollView.snp.makeConstraints {
            $0.top.equalTo(photoLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
        }
        
        [minusImageView1, minusImageView2, minusImageView3].forEach { imageView in
            imageView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(5)
                $0.trailing.equalToSuperview().offset(-5)
                $0.size.equalTo(16)
            }
        }
        
        borderLine.snp.makeConstraints {
            $0.top.equalTo(navigationHStackView.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(56)
        }
        
        navigationHStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            $0.leading.trailing.equalToSuperview().inset(18)
        }
    }
}

extension PhotoSelectionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        requirementTextView.layer.borderColor = UIColor.second1.cgColor
        placeholder.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        requirementTextView.layer.borderColor = UIColor.gray4.cgColor
        
        if textView.text.count == 0 {
            placeholder.isHidden = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) /// 화면을 누르면 키보드 내려가게 하는 것
    }
    
    func textViewDidChange(_ textView: UITextView) {
    }
}
