//
//  PhotoAuthService.swift
//  WHOA_iOS
//
//  Created by KSH on 3/13/24.
//

import Photos
import UIKit

/*
 notDetermined = 사용자가 권한을 설정하지 않은 상태
 restricted = 사용자가 권한을 부여할 수 없는 상태
 denied = 권한을 거부한 상태
 authorized = 사용자가 권한을 승인한 상태
 limited = 사용자가 일부 제한된 권한을 승인한 상태
 */

protocol PhotoAuthService {
    var authorizationStatus: PHAuthorizationStatus { get }
    var isAuthorizationLimited: Bool { get }
    
    func requestAuthorization(completion: @escaping (Result<Void, NSError>) -> Void)
}

extension PhotoAuthService {
    var isAuthorizationLimited: Bool {
        authorizationStatus == .limited
    }
    
    fileprivate func goToSetting() {
        guard
            let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url)
        else { return }
            
        UIApplication.shared.open(url, completionHandler: nil)
    }
}

final class MyPhotoAuthService: PhotoAuthService {
    var authorizationStatus: PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    func requestAuthorization(completion: @escaping (Result<Void, NSError>) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .notDetermined:
                completion(.failure(.init()))
            case .denied, .restricted:
                DispatchQueue.main.async { self.showDeniedAlert() }
                completion(.failure(.init()))
            case .authorized, .limited:
                DispatchQueue.main.async { completion(.success(())) }
            @unknown default:
                print("PHPhotoLibrary::execute - \"Unknown case\"")
            }
        }
    }
    
    private func showDeniedAlert() {
        let alert = UIAlertController(title: "권한 거부됨", message: "사진 앨범에 접근할 수 있는 권한이 거부되었습니다. 설정에서 권한을 허용해주세요.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            self.goToSetting()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            windowScene.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
