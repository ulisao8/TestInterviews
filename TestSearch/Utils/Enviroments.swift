//
//  Enviroments.swift
//  TestSearch
//
//  Created by Ulises Gonzalez on 26/01/24.
//

import Foundation
// MARK: - Enviroments to handle differents urls

struct Environment {
    enum EnvironmentType {
        case development
        case staging
        case production
    }

    static var current: EnvironmentType = .development
    static var baseURL: String {
        switch current {
        case .development:
            return "https://api.flickr.com/"
        case .staging:
            return "https://api.flickr.com/"
        case .production:
            return "https://api.flickr.com/"
        }
    }

   
}
