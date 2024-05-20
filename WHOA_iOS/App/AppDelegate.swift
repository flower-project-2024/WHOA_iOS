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
            print("첫 시작")
            initializeAppConfig()
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    // MARK: - Functions
    
    private func initializeAppConfig() {
        guard KeychainManager.shared.loadMemberId() == nil else { return }
        registerMember()
    }
    
    private func registerMember() {
        let memberRegisterRequestDTO = MemberRegisterRequestDTO(deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "")
        
        NetworkManager.shared.postMemberRegister(memberRegisterRequestDTO: memberRegisterRequestDTO) { [weak self] result in
            switch result {
            case .success(let memberRegisterDTO):
                let memberId = String(memberRegisterDTO.data.id)
                KeychainManager.shared.saveMemberId(memberId)
                
                UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                UserDefaults.standard.synchronize()
            case .failure(let error):
                self?.networkErrorAlert(error)
            }
        }
    }
    
    private func networkErrorAlert(_ error: NetworkError) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "네트워크 에러 발생했습니다‼️", message: error.localizedDescription, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "다시시도", style: .default) { _ in
                self.registerMember()
            }
            
            alertController.addAction(confirmAction)
            
            if let window = self.window, let rootVC = window.rootViewController {
                rootVC.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

