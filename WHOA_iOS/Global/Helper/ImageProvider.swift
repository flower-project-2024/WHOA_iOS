//
//  ImageProvider.swift
//  WHOA_iOS
//
//  Created by KSH on 7/14/24.
//

import UIKit

/// 로직
/// 1. urlString을 key로 하는 UIImage가 캐시에 있는지 확인
/// 2. 존재한다면 completionHandler로 이미지 전달
/// 3. 없다면 urlString에서 UIImage로 변환
/// 4. 변환된 UIImage를 Value, 매개변수로 전달받은 urlString을 Key로 하여 캐시에 저장
/// 5. completionHandler를 통해 변환된 UIImage를 전달

class ImageProvider {
    static let shared = ImageProvider()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    /// 이미지를 URL에서 로드하여 캐시하고, 완료 핸들러를 통해 반환합니다.
    /// - Parameters:
    ///   - urlString: 로드할 이미지의 URL 문자열입니다.
    ///   - qos: 작업에 사용할 서비스 품질을 정하는 파라미터입니다. 기본값은 `.default`입니다.
    ///   - completionHandler: 이미지를 반환하는 완료 핸들러입니다. 이미지 로드가 완료되면 호출됩니다.
    func loadImage(
        urlString: String,
        qos: DispatchQoS.QoSClass = .default,
        completionHandler: @escaping (_ image: UIImage?) -> ()
    ) {
        // 캐시된 이미지 확인
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                completionHandler(cachedImage)
            }
        }
        
        // 백그라운드에서 이미지 로드
        DispatchQueue.global(qos: qos).async {
            guard let url = URL(string: urlString) else { return }
            
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                // 이미지 캐시에 저장
                self.cache.setObject(image, forKey: urlString as NSString, cost: 1)
                DispatchQueue.main.async {
                    completionHandler(image)
                }
            }
        }
    }
    
    /// 이미지를 URL에서 로드하여 UIImageView에 설정합니다.
    /// - Parameters:
    ///   - imageView: 이미지를 설정할 UIImageView 객체입니다.
    ///   - qos: 작업에 사용할 서비스 품질을 정하는 파라미터입니다. 기본값은 `.default`입니다.
    ///   - urlString: 로드할 이미지의 URL 문자열입니다.
    func setImage(
        into imageView: UIImageView,
        qos: DispatchQoS.QoSClass = .default,
        from urlString: String
    ) {
        loadImage(urlString: urlString, qos: qos) { image in
            imageView.image = image
        }
    }
}
