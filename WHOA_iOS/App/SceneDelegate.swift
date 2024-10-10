//
//  SceneDelegate.swift
//  WHOA_iOS
//
//  Created by KSH on 2/4/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = configRootViewController()
        window?.makeKeyAndVisible()
    }
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

extension SceneDelegate {
    private func configRootViewController() -> UIViewController {
        let isOnboardingCompleted = UserDefaults.standard.bool(forKey: "isOnboardingCompleted")
        
        if isOnboardingCompleted {
            return TabBarViewController()
        } else {
            UserDefaults.standard.set(true, forKey: "isOnboardingCompleted")
            return OnboardingViewController()
        }
    }
}

