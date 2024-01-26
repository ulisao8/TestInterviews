//
//  TestSearchTests.swift
//  TestSearchTests
//
//  Created by Ulises Gonzalez on 26/01/24.
//

import XCTest
import Combine
@testable import TestSearch


class FlickrSearchViewModelTests: XCTestCase {
    var viewModel: FlickrSearchViewModel!
    var fakeDataProvider: FakeFlickrDataProvider!
    var cancellables: Set<AnyCancellable>!

//  Our data provider allows us to use a fake one without changing our viewmodel, here we use dependency injection in a basic way
    
    override func setUp() {
        super.setUp()
        fakeDataProvider = FakeFlickrDataProvider()
        viewModel = FlickrSearchViewModel(dataProvider: fakeDataProvider)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        fakeDataProvider = nil
        cancellables = nil
        super.tearDown()
    }
    
    // We can also get data fake from a json file inside of the app
    
    func testLoadItemFromJSON() {
            let bundle = Bundle(for: type(of: self))
            guard let url = bundle.url(forResource: "item", withExtension: "json") else {
                XCTFail("Missing file: item.json")
                return
            }

            do {
                let data = try Data(contentsOf: url)
                let item = try JSONDecoder().decode(Item.self, from: data)
                
                XCTAssertEqual(item.title, "Test Images items")
                XCTAssertEqual(item.media.m, "url from the json file")
            
            } catch {
                XCTFail("Decoding error: \(error)")
            }
        }

    // Mocking the data harcode
    func testFetchImagesSuccess() {
       
        let expectedItems = [Item(title: "Test Image", link: "https://example.com/image.jpg", media: Media(m: "https://example.com/image.jpg"), dateTaken: "2020-01-01T00:00:00Z", description: "Description", published: "2020-01-01T00:00:00Z", author: "Author", authorId: "authorId", tags: "tags")]
        
        fakeDataProvider.fetchImagesResult = Just(expectedItems).setFailureType(to: Error.self).eraseToAnyPublisher()

        let expectation = XCTestExpectation(description: "Fetch images from Fake Data Provider")

        viewModel.$items
            .dropFirst()
            .sink { items in
                XCTAssertEqual(items.count, expectedItems.count)
                XCTAssertEqual(items.first?.title, expectedItems.first?.title)
                expectation.fulfill() // all good when we recieve the data
            }
            .store(in: &cancellables)

        // Activating the search
        viewModel.searchText = "airplanes"

        // Wait to achieve the expectations.
        wait(for: [expectation], timeout: 5.0) // Aumenta el timeout si es necesario
    }
}
