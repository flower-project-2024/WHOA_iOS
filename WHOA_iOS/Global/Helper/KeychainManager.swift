//
//  KeychainManager.swift
//  WHOA_iOS
//
//  Created by KSH on 5/14/24.
//

import Security
import Foundation

protocol KeychainAccessible {
    func saveMemberId(_ memberId: String)
    func loadMemberId() -> String?
}

class KeychainManager: KeychainAccessible {
    static let shared = KeychainManager()
    
    private init() {}
    
    private let service = "suyeon.WHOA-iOS"
    private let account = "MemberId"
    
    func saveMemberId(_ memberId: String) {
        let data = Data(memberId.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        // 먼저 기존 데이터 삭제 시도
        SecItemDelete(query as CFDictionary)
        
        // 새 데이터 추가
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("키체인에 MemberId를 저장하는 중에 오류가 발생했습니다‼️: \(status)")
            return
        }
    }
    
    func loadMemberId() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data, let memberId = String(data: data, encoding: .utf8) else {
            print("키체인에서 MemberId를 검색하는 중에 오류가 발생했습니다‼️: \(status)")
            return nil
        }
        return memberId
    }
    
    func deleteMemberId() -> Bool {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account
            ]

            let status = SecItemDelete(query as CFDictionary)
            if status == errSecSuccess {
                print("MemberId가 키체인에서 삭제되었습니다‼️")
                return true
            } else {
                print("키체인에서 MemberId를 삭제하지 못했습니다‼️ \(status)")
                return false
            }
        }
}
