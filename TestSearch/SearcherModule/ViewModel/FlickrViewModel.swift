//
//  FlickrViewModel.swift
//  TestSearch
//
//  Created by Ulises Gonzalez on 26/01/24.
//

import Combine
import Foundation
import UIKit

// MARK: - ViewModel With Combine
// Combine works very good with the SwiftUI arquitecture

class FlickrSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published private(set) var items: [Item] = []
    @Published private(set) var images: [String: UIImage] = [:]

    private var cancellables = Set<AnyCancellable>()
    private let dataProvider: FlickrDataProviderProtocol

//    Our data provider allows us to use a fake one without changing our viewmodel, here we use dependency injection in a basic way
    
    init(dataProvider: FlickrDataProviderProtocol = FlickrDataProvider()) {
        self.dataProvider = dataProvider

        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { [unowned self] searchText in
                self.dataProvider.fetchImages(for: searchText)
                    .catch { _ in Just([]) }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.items, on: self)
            .store(in: &cancellables)

        // Check changes on `items` y load images
        $items
            .flatMap { items in
                Publishers.MergeMany(items.map { item in
                    self.dataProvider.downloadImage(from: item.media.m)
                        .map { (item.media.m, $0) } // We associate every image with the url
                })
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url, image in
                guard let image = image else { return }
                self?.images[url] = image
            }
            .store(in: &cancellables)
    }
}
