//
//  AppDelegate.swift
//  WHOA_iOS
//
//  Created by KSH on 2/4/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        
        if !isFirstLaunch {
            initializeAppConfig()
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}

// MARK: - save MemberId in keychain
extension AppDelegate {
    private func initializeAppConfig() {
        guard KeychainManager.shared.loadMemberId() == nil else { return }
        registerMember()
    }
    
    private func registerMember() {
        let memberRegisterRequestDTO = MemberRegisterRequestDTO(deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "")
        
        NetworkManager.shared.createMemberRegister(memberRegisterRequestDTO: memberRegisterRequestDTO) { [weak self] result in
            switch result {
            case .success(let memberRegisterDTO):
                let memberId = String(memberRegisterDTO.data.id)
                KeychainManager.shared.saveMemberId(memberId)
                
                UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                UserDefaults.standard.synchronize()
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
}

// MARK: - Error -> Alert
extension AppDelegate {
    func handleError(_ error: NetworkError) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        if let presentViewController = window.rootViewController {
            presentViewController.showAlert(title: "네트워킹 오류", message: error.localizedDescription)
        } else {
            fatalError(error.localizedDescription)
        }
    }
}
