//
//  TabBarViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/8/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    private let customizeButtonWidth = 69
    private var buttonConfig = UIButton.Configuration.plain()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.tintColor = UIColor.primary
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = UIColor.gray07
        tabBar.layer.masksToBounds = false
        
        let customizingVC = BuyingIntentViewController(viewModel: BuyingIntentViewModel())
        
        let homeNavVC = UINavigationController(rootViewController: HomeViewController())
        let customizingNavVC = UINavigationController(rootViewController: customizingVC)
        let myPageNavVC = UINavigationController(rootViewController: MyPageViewController())
        
        self.setViewControllers([homeNavVC, customizingNavVC, myPageNavVC], animated: true)
        
        if let items = self.tabBar.items {
            items[0].selectedImage = UIImage.homeIconFilled
            items[0].image = UIImage.homeIcon
            items[0].title = "홈"
            items[0].tag = 0
            items[0].setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Pretendard-Regular", size: 12) as Any], for: .normal)
            items[0].setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Pretendard-SemiBold", size: 12) as Any], for: .selected)
            items[0].titlePositionAdjustment = .init(horizontal: 20, vertical: 0)
            
            items[1].selectedImage = UIImage.customizeIconFilled.withRenderingMode(.alwaysOriginal)
            items[1].image = UIImage.customizeIcon.withRenderingMode(.alwaysOriginal)
            items[1].title = "커스터마이징"
            items[1].imageInsets = UIEdgeInsets(top: -21, left: 0, bottom: 10, right: 0)
            items[1].tag = 1
            items[1].setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Pretendard-Regular", size: 12) as Any], for: .normal)
            items[1].titlePositionAdjustment = .init(horizontal: 3, vertical: 0)
            
            items[2].selectedImage = UIImage.mypageIconFilled
            items[2].image = UIImage.mypageIcon
            items[2].title = "마이페이지"
            items[2].tag = 2
            items[2].setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Pretendard-Regular", size: 12) as Any], for: .normal)
            items[2].setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Pretendard-SemiBold", size: 12) as Any], for: .selected)
            items[2].titlePositionAdjustment = .init(horizontal: -20, vertical: 0)
        }
        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: UIColor.gray02, alpha: 1, x: 0, y: -2, blur: 6)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        var tabFrame = self.tabBar.frame
//        tabFrame.size.height = 92
//        tabFrame.origin.y = self.view.frame.size.height - 92
//        self.tabBar.frame = tabFrame
//    }
}

// MARK: - Extension

// TODO: global - extension으로 빼기
extension UITabBar {
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}

extension CALayer {
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}
