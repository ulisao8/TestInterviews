//
//  DataProvider.swift
//  TestSearch
//
//  Created by Ulises Gonzalez on 26/01/24.
//

import Foundation
import Combine
import UIKit

protocol FlickrDataProviderProtocol {
    func fetchImages(for searchText: String) -> AnyPublisher<[Item], Error>
    func downloadImage(from urlString: String) -> AnyPublisher<UIImage?, Never>
}

// MARK: - DataProvider
// We split the Networking logic in a data provider, also useful for the dummy testing, we can use a data provider fake

class FlickrDataProvider: FlickrDataProviderProtocol {
   
    private let baseUrl = Environment.baseURL + "services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags="
  
    func fetchImages(for searchText: String) -> AnyPublisher<[Item], Error> {
        guard !searchText.isEmpty, let url = URL(string: baseUrl + searchText.replacingOccurrences(of: " ", with: ",")) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: FlickrFeed.self, decoder: JSONDecoder())
            .map(\.items)  // Seleccionar solo los 'items' de la respuesta
            .eraseToAnyPublisher()
    }

    func downloadImage(from urlString: String) -> AnyPublisher<UIImage?, Never> {
        // Check if images exits in cache
        if let cachedImage = ImageCache.shared.getImage(forKey: urlString) {
            return Just(cachedImage).eraseToAnyPublisher()
        }

        // if not we download it from the url
        guard let url = URL(string: urlString) else {
            return Just(nil).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { response -> UIImage? in
               
                let image = UIImage(data: response.data)
                // Store image in cache
                if let image = image {
                    ImageCache.shared.setImage(image, forKey: urlString)
                }
                return image
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}

// MARK: - Fake DataProvider for testing
class FakeFlickrDataProvider: FlickrDataProviderProtocol {
    var fetchImagesResult: AnyPublisher<[Item], Error> = Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    var downloadImageResult: [String: AnyPublisher<UIImage?, Never>] = [:]

    func fetchImages(for searchText: String) -> AnyPublisher<[Item], Error> {
        return fetchImagesResult
    }

    func downloadImage(from urlString: String) -> AnyPublisher<UIImage?, Never> {
        return downloadImageResult[urlString] ?? Just(nil).eraseToAnyPublisher()
    }
}
