//
//  FileUIImageView+.swift
//  WHOA_iOS
//
//  Created by KSH on 4/5/24.
//

import UIKit

extension UIImageView {
    func load(url: URL, completion: ((UIImage?) -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                    completion?(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion?(nil)
                }
            }
        }
    }
}

func urlStringToImageFile(urlString: String, filename: String, completion: @escaping (ImageFile?) -> Void) {
    guard let url = URL(string: urlString) else {
        print("Error: Invalid URL string")
        completion(nil)
        return
    }

    DispatchQueue.main.async {
        let imageView = UIImageView()
        imageView.load(url: url) { image in
            guard let image = image, let pngData = image.pngData() else {
                print("Error: Could not create ImageFile from URL")
                completion(nil)
                return
            }

            let imageFile = ImageFile(filename: filename, data: pngData, type: "image/png")
            completion(imageFile)
        }
    }
}
