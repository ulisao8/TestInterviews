//
//  ImageCache.swift
//  TestSearch
//
//  Created by Ulises Gonzalez on 26/01/24.
//

import Foundation
import UIKit

// MARK: - Cache
// Small class to save the cache and improve the performance.

class ImageCache {
    static let shared = ImageCache()
    private init() {}

    private var cache = NSCache<NSString, UIImage>()

    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
