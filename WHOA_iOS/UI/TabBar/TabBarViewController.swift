//
//  TabBarViewController.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/8/24.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    private var customizingCoordinator: CustomizingCoordinator?
    private var customizingNavVC: UINavigationController?
    private var hasBottomInset: Bool?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self

        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let firstWindow = windowScene?.windows.first
        hasBottomInset = firstWindow?.safeAreaInsets.bottom ?? 0 > 0  // true면 베젤이 있음, false면 베젤 없음(=se)
        
        tabBar.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.tintColor = UIColor.primary
        tabBar.isTranslucent = false
        tabBar.unselectedItemTintColor = UIColor.gray07
        tabBar.layer.masksToBounds = false
        
        setTabBarHeightAndSettings()
        setTabViewControllers()
        setTabBarItems()
        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: UIColor.gray02, alpha: 1, width: 0, height: -2, blur: 6)
        
        self.selectedIndex = 0
    }
    
    // MARK: - Functions
    
    /// 탭바와 연결될 뷰컨트롤러 세팅하는 함수
    private func setTabViewControllers() {
        customizingNavVC = UINavigationController()
        if let customizingNavVC = customizingNavVC {
            customizingCoordinator = CustomizingCoordinator(navigationController: customizingNavVC)
            customizingCoordinator?.start()
        }
        
        let homeVC = HomeViewController()
        homeVC.customizingCoordinator = customizingCoordinator
        let homeNavVC = UINavigationController(rootViewController: homeVC)
        
        let myPageVC = MyPageViewController()
        myPageVC.customizingCoordinator = customizingCoordinator
        let myPageNavVC = UINavigationController(rootViewController: myPageVC)
        
        if let customizingNavVC = customizingNavVC {
            self.setViewControllers([homeNavVC, customizingNavVC, myPageNavVC], animated: true)
        } else {
            self.setViewControllers([homeNavVC, myPageNavVC], animated: true)
        }
    }
    
    /// 탭바의 각 탭 아이템들을 세팅하는 함수
    private func setTabBarItems() {
        if let items = self.tabBar.items {
            if hasBottomInset! {
                items[0].selectedImage = UIImage.homeIconFilled
                items[0].image = UIImage.homeIcon
                items[0].titlePositionAdjustment = .init(horizontal: 20, vertical: 0)
                
                items[1].selectedImage = UIImage.customizeIconFilled.withRenderingMode(.alwaysOriginal)
                items[1].image = UIImage.customizeIcon.withRenderingMode(.alwaysOriginal)
                items[1].imageInsets = UIEdgeInsets(top: -21, left: 0, bottom: 10, right: 0)
                items[1].titlePositionAdjustment = .init(horizontal: 0, vertical: 0)
                
                items[2].selectedImage = UIImage.mypageIconFilled
                items[2].image = UIImage.mypageIcon
                items[2].titlePositionAdjustment = .init(horizontal: -20, vertical: 0)
            }
            else {
                items[0].selectedImage = UIImage.homeIconFilledSe
                items[0].image = UIImage.homeIconSe
                items[0].imageInsets = UIEdgeInsets(top: -7, left: 0, bottom: 7, right: 0)
                items[0].titlePositionAdjustment = .init(horizontal: 20, vertical: -15)
                
                items[1].selectedImage = UIImage.customizeIconFilledSe.withRenderingMode(.alwaysOriginal)
                items[1].image = UIImage.customizeIconSe.withRenderingMode(.alwaysOriginal)
                items[1].imageInsets = UIEdgeInsets(top: -26, left: 0, bottom: 15, right: 0)
                items[1].titlePositionAdjustment = .init(horizontal: 0, vertical: -15)
                
                items[2].selectedImage = UIImage.mypageIconFilledSe
                items[2].image = UIImage.mypageIconSe
                items[2].imageInsets = UIEdgeInsets(top: -7, left: 0, bottom: 7, right: 0)
                items[2].titlePositionAdjustment = .init(horizontal: -20, vertical: -15)
            }
            
            items[0].title = "홈"
            items[0].setTitleTextAttributes([NSAttributedString.Key.font : UIFont.Pretendard(size: 12, family: .Regular)], for: .normal)
            items[0].setTitleTextAttributes([NSAttributedString.Key.font : UIFont.Pretendard(size: 12, family: .SemiBold)], for: .selected)

            items[1].title = "커스터마이징"
            items[1].setTitleTextAttributes([NSAttributedString.Key.font : UIFont.Pretendard(size: 12, family: .Regular)], for: .normal)
            items[1].setTitleTextAttributes([NSAttributedString.Key.font : UIFont.Pretendard(size: 12, family: .SemiBold)], for: .selected)

            items[2].title = "마이페이지"
            items[2].setTitleTextAttributes([NSAttributedString.Key.font : UIFont.Pretendard(size: 12, family: .Regular)], for: .normal)
            items[2].setTitleTextAttributes([NSAttributedString.Key.font : UIFont.Pretendard(size: 12, family: .SemiBold)], for: .selected)
        }
    }
    
    /// 탭바 높이 조정하는 메소드
    private func setTabBarHeightAndSettings() {
        let customTabBar = CustomTabBar()
        customTabBar.customHeight = hasBottomInset! ? 92 : 75 // 베젤이 있는 경우와 없는 경우의 높이 설정
        
        customTabBar.barTintColor = .white
        customTabBar.tintColor = .primary
        setValue(customTabBar, forKey: "tabBar")
    }
}

// MARK: - Extension: UITabBarControllerDelegate

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == customizingNavVC {
            customizingCoordinator?.setActionType(actionType: .create)
        }
    }
}
