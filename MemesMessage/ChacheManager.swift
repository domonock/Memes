//
//  ChacheManager.swift
//  MemesMessage
//
//  Created by Volodymyr Babych on 05.02.2024.
//

import UIKit

class ChacheManager {
    private var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        return cache
    }()
    
    func fillImage(from url: URL, completion: @escaping (UIImage?) -> ()) {
        let imageUrlString = url.absoluteString
        if let cachedImage = imageCache.object(forKey: imageUrlString as NSString) {
            completion(cachedImage)
            print("CHACHE WORKED")
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageData = try? Data(contentsOf: url),
                  let image = UIImage(data: imageData) else {
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
