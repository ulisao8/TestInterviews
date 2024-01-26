//
//  ContentView.swift
//  TestSearch
//
//  Created by Ulises Gonzalez on 26/01/24.
//

import SwiftUI

struct FlickrView: View {
    @StateObject private var viewModel = FlickrSearchViewModel()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $viewModel.searchText).accessibilityIdentifier("searchTextField")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if viewModel.items.isEmpty && !viewModel.searchText.isEmpty {
                    Spacer()
                    Text("No Results Found")
                        .accessibilityIdentifier("noResultsText")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List(viewModel.items) { item in
                        HStack {
                            if let image = viewModel.images[item.media.m] {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                            } else {
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(item.title).font(.headline)
                                Text(item.author).font(.subheadline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Flickr Search")
        }
    }
}
