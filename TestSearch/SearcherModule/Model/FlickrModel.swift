//
//  FlickrModel.swift
//  TestSearch
//
//  Created by Ulises Gonzalez on 26/01/24.
//

import Foundation

struct FlickrFeed: Decodable {
    let title: String
    let link: String
    let description: String
    let modified: String
    let generator: String
    let items: [Item]
}

struct Item: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let link: String
    let media: Media
    let dateTaken: String
    let description: String
    let published: String
    let author: String
    let authorId: String
    let tags: String

    private enum CodingKeys: String, CodingKey {
        case title, link, media, description, published, author, tags
        case dateTaken = "date_taken"
        case authorId = "author_id"
    }
}

struct Media: Decodable {
    let m: String
}
