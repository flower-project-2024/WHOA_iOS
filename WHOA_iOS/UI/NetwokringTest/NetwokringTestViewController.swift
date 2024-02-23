//
//  NetwokringTestViewController.swift
//  WHOA_iOS
//
//  Created by KSH on 2/23/24.
//

import UIKit

/// 네트워킹 예시를 보여주기 위한 임시 VC입니다.
class NetwokringTestViewController: UIViewController {
    
    override func viewDidLoad() {
        NetworkManager.shared.fetchNetworkingTest { result in
            print(result)
        }
    }
}
