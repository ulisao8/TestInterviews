//
//  TestSearchUITests.swift
//  TestSearchUITests
//
//  Created by Ulises Gonzalez on 26/01/24.
//

import XCTest

import XCTest

class FlickrViewUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }

    func testSearchFunctionality() throws {
        let app = XCUIApplication()

        let searchTextField = app.textFields["searchTextField"]
        XCTAssertTrue(searchTextField.exists)
        searchTextField.tap()
        searchTextField.typeText("porcupine\n")
        
        let noResultsText = app.staticTexts["noResultsText"]
        if noResultsText.exists {
            XCTAssertTrue(noResultsText.isHittable)
            
        } else {
//           other conditions
        }
    }
}
