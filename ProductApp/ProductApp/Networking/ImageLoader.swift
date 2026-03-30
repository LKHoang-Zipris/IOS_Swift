//
//  ImageLoader.swift
//  ProductApp
//
//  Created by Lê Kim Hoàng on 30/3/26.
//


import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let key = NSString(string: urlString)
        
        if let cachedImage = cache.object(forKey: key) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self?.cache.setObject(image, forKey: key)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}