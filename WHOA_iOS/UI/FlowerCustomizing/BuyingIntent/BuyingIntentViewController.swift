//
//  BuyingIntentViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/5/24.
//

import UIKit
import SnapKit

class BuyingIntentViewController: UIViewController {
    
    // MARK: - Properties
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .systemGray6
        progressView.progressTintColor = .black
        progressView.progress = 1 / 7
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        return progressView
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = " 1 / 7"
        return label
    }()
    
    private lazy var progressStackView: UIStackView = {
        let stackView = UIStackView()
        [progressView, progressLabel].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "꽃다발 구매 목적"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "목적에 맞는 꽃말을 가진 꽃들을 추천해드릴게요"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 2
        return label
    }()
    
    private let intentButton: UIButton = {
        var config = UIButton.Configuration.gray()
        config.title = "회갑 / 칠순 / 연회"
        config.baseForegroundColor = .black
        config.image = UIImage(named: "IntentImage")
        config.imagePlacement = .top
        config.imagePadding = 10
        
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let intentButton2: UIButton = {
        var config = UIButton.Configuration.gray()
        config.title = "생일 / 기념일"
        config.baseForegroundColor = .black
        config.image = UIImage(named: "IntentImage")
        config.imagePlacement = .top
        config.imagePadding = 10
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private let intentButton3: UIButton = {
        var config = UIButton.Configuration.gray()
        config.title = "추모 / 근조 / 장례식"
        config.baseForegroundColor = .black
        config.image = UIImage(named: "IntentImage")
        config.imagePlacement = .top
        config.imagePadding = 10
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private let intentButton4: UIButton = {
        var config = UIButton.Configuration.gray()
        config.title = "결혼식 / 취임식"
        config.baseForegroundColor = .black
        config.image = UIImage(named: "IntentImage")
        config.imagePlacement = .top
        config.imagePadding = 10
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private let intentButton5: UIButton = {
        var config = UIButton.Configuration.gray()
        config.title = "애정표현"
        config.baseForegroundColor = .black
        config.image = UIImage(named: "IntentImage")
        config.imagePlacement = .top
        config.imagePadding = 10
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private let intentButton6: UIButton = {
        var config = UIButton.Configuration.gray()
        config.title = "승진 / 취업"
        config.baseForegroundColor = .black
        config.image = UIImage(named: "IntentImage")
        config.imagePlacement = .top
        config.imagePadding = 10
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private let intentButton7: UIButton = {
        var config = UIButton.Configuration.gray()
        config.title = "전시 / 공연"
        config.baseForegroundColor = .black
        config.image = UIImage(named: "IntentImage")
        config.imagePlacement = .top
        config.imagePadding = 10
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private let intentButton8: UIButton = {
        var config = UIButton.Configuration.gray()
        config.title = "수상 / 입학 / 졸업"
        config.baseForegroundColor = .black
        config.image = UIImage(named: "IntentImage")
        config.imagePlacement = .top
        config.imagePadding = 10
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private let intentButton9: UIButton = {
        var config = UIButton.Configuration.gray()
        config.title = "전시 / 공연"
        config.baseForegroundColor = .black
        config.image = UIImage(named: "IntentImage")
        config.imagePlacement = .top
        config.imagePadding = 10
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private let intentButton10: UIButton = {
        var config = UIButton.Configuration.gray()
        config.title = "수상 / 입학 / 졸업"
        config.baseForegroundColor = .black
        config.image = UIImage(named: "IntentImage")
        config.imagePlacement = .top
        config.imagePadding = 10
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var intentButtonStackView: UIStackView = {
        let stackView = UIStackView()
        [intentButton, intentButton2].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 9
        return stackView
    }()
    
    private lazy var intentButtonStackView2: UIStackView = {
        let stackView = UIStackView()
        [intentButton3, intentButton4].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 9
        return stackView
    }()
    
    private lazy var intentButtonStackView3: UIStackView = {
        let stackView = UIStackView()
        [intentButton5, intentButton6].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 9
        return stackView
    }()
    
    private lazy var intentButtonStackView4: UIStackView = {
        let stackView = UIStackView()
        [intentButton7, intentButton8].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 9
        return stackView
    }()
    
    private lazy var intentButtonStackView5: UIStackView = {
        let stackView = UIStackView()
        [intentButton9, intentButton10].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 9
        return stackView
    }()
    
    private lazy var intentButtonStackView6: UIStackView = {
        let stackView = UIStackView()
        [intentButtonStackView, intentButtonStackView2, intentButtonStackView3, intentButtonStackView4, intentButtonStackView5].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 9
        return stackView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("이전", for: .normal)
        button.backgroundColor = .systemGray5
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.backgroundColor = .systemGray5
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var navigationStackView: UIStackView = {
        let stackView = UIStackView()
        [backButton, nextButton].forEach { stackView.addArrangedSubview($0)}
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 9
        return stackView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(progressStackView)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(intentButtonStackView6)
        view.addSubview(navigationStackView)

        
        setupAutoLayout()
    }
    
    @objc
    func buttonTapped() {
        print("Button tapped!")
    }
}

extension BuyingIntentViewController {
    private func setupAutoLayout() {
        progressStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(39)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(13.875)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-13.125)
            $0.height.equalTo(12.75)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressStackView).offset(16)
            $0.leading.equalTo(view).offset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(32)
            $0.leading.equalTo(view).offset(20)
            $0.width.equalTo(150)
        }
        
        intentButtonStackView6.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp_bottomMargin).offset(27)
            $0.leading.equalTo(view).offset(15.75)
            $0.trailing.equalTo(view).offset(-15.75)

        }
        
        navigationStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.leading.equalTo(view).offset(20)
            $0.trailing.equalTo(view).offset(-11.5)
        }
        
    }
}
