//
//  ImageCache.swift
//  Vegan russia search
//
//  Created by Владимир Дельгадильо on 31.03.2021.
//

import UIKit

class ImageCache {
    
    let imageCache = NSCache<NSString, UIImage>()
    
    func getImage(relativeUrl: String, completion: @escaping (UIImage) -> Void) {
        
        if let cache = imageCache.object(forKey: relativeUrl as NSString) {
            completion(cache)
        } else {
            if let tempImage = UIImage(named: "emptyVgStory") {
                completion(tempImage)
            }
            var imageUrl: URL?
            
            if relativeUrl.contains("https://veganrussian.ru") {
                imageUrl = URL(string: relativeUrl)
            } else {
                imageUrl = URL(string: "https://veganrussian.ru\(relativeUrl)")
            }
            
            guard let url = imageUrl else {
                return
            }

            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard data != nil, let response = response as? HTTPURLResponse, response.statusCode == 200, error == nil, let `self` = self else {
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else { return }
                self.imageCache.setObject(image, forKey: relativeUrl as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            task.resume()
        }
        
    }
}
