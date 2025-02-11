//
//  ImageProvider.swift
//  WHOA_iOS
//
//  Created by KSH on 7/14/24.
//

import UIKit

final class DiskCache {
    static let shared = DiskCache()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        // iOS에서 Caches 디렉토리를 찾아 "ImageCache" 폴더를 생성
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache")
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    /// key(예: urlString)에 해당하는 파일 URL
    private func fileURL(for key: String) -> URL {
        // 파일 이름으로 사용할 수 없는 문자( :, /, ? 등 )를 치환
        let fileName = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? key
        return cacheDirectory.appendingPathComponent(fileName)
    }
    
    /// 이미지를 디스크에 저장
    func save(image: UIImage, for key: String) {
        let fileURL = fileURL(for: key)
        // JPEG 80% 압축 (압축률은 필요에 따라 조정 가능)
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: fileURL)
        }
    }
    
    /// 디스크에서 이미지를 로드
    func load(for key: String) -> UIImage? {
        let fileURL = fileURL(for: key)
        guard
            let data = try? Data(contentsOf: fileURL),
            let image = UIImage(data: data)
        else {
            return nil
        }
        return image
    }
    
    /// 디스크 캐시 전체 삭제 (필요할 때 호출)
    func clear() {
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
}

final class ImageProvider {
    static let shared = ImageProvider()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    
    // 생성자 접근 제한(싱글톤)
    private init() {}
    
    /// URL로부터 이미지를 비동기적으로 로드하고,
    /// 메모리 & 디스크 캐시에 저장합니다.
    func loadImage(
        urlString: String,
        completion: @escaping (UIImage?) -> Void
    ) {
        // 1) 메모리 캐시에 있으면 즉시 반환
        if let cachedImage = memoryCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        // 2) 디스크 캐시 확인
        if let diskImage = DiskCache.shared.load(for: urlString) {
            // 디스크에서 꺼낸 이미지를 메모리 캐시에 다시 올려줌
            memoryCache.setObject(diskImage, forKey: urlString as NSString)
            
            completion(diskImage)
            return
        }
        
        // 3) URL 객체 생성 실패 시 nil 반환
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // 4) URLSession 비동기 요청
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard
                let self = self,
                let data = data,
                let image = UIImage(data: data)
            else {
                // 실패면 nil 반환
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // 5) 메모리 캐시에 저장 (cost는 데이터 크기로 설정)
            self.memoryCache.setObject(image, forKey: urlString as NSString, cost: data.count)
            
            // 6) 디스크 캐시에도 저장
            DiskCache.shared.save(image: image, for: urlString)
            
            // 7) 메인 스레드에서 completion 실행
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    /// UIImageView에 이미지를 설정합니다.
    func setImage(into imageView: UIImageView, from urlString: String) {
        loadImage(urlString: urlString) { image in
            // UI 업데이트는 메인 스레드에서
            imageView.image = image
        }
    }
}
