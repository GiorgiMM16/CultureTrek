//
//  UIImageView.swift
//  CultureTrek
//
//  Created by Giorgi Michitashvili on 7/14/24.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            self.image = image
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let response = response, let image = UIImage(data: data) {
                let cachedData = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedData, for: request)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
