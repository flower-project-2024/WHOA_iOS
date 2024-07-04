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
    private var customizingCoordinator: CustomizingCoordinator?
    
    private var customizingNavVC: UINavigationController?
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        tabBar.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.tintColor = UIColor.primary
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = UIColor.gray07
        tabBar.layer.masksToBounds = false
        
        let homeNavVC = UINavigationController(rootViewController: HomeViewController())
        
        customizingNavVC = UINavigationController()
        if let customizingNavVC = customizingNavVC {
            customizingCoordinator = CustomizingCoordinator(navigationController: customizingNavVC)
            customizingCoordinator?.start()
        }
        
        let myPageVC = MyPageViewController()
        myPageVC.customizingCoordinator = customizingCoordinator
        let myPageNavVC = UINavigationController(rootViewController: myPageVC)
        
        if let customizingNavVC = customizingNavVC {
            self.setViewControllers([homeNavVC, customizingNavVC, myPageNavVC], animated: true)
        } else {
            self.setViewControllers([homeNavVC, myPageNavVC], animated: true)
        }
        
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
}

// MARK: - UITabBarControllerDelegate

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == customizingNavVC {
            customizingCoordinator?.setActionType(actionType: .create)
        }
    }
}
