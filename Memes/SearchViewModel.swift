//
//  SearchViewModel.swift
//  Memes
//
//  Created by Volodymyr Babych on 13.12.2023.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searchItems: [RedditPostModel] = []
    @Published var isLoading = false
    @Published var afterID: String? = nil
    let networking = Networking()
    func fetchSearchResults(searchTerm: String) {
        isLoading = true
        networking.fetchSearchResults(searchTerm: searchTerm) {[weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let responce):
                if self?.searchItems.last != responce.post.last {
                    self?.searchItems += responce.post
                }
                if responce.afterID == self?.afterID {
                    self?.afterID = nil
                } else {
                    self?.afterID = responce.afterID
                }
                print("Fetched \(responce.post.count) posts")
            case .failure(let error):
                // Show error alert
                print("Error fetching posts: \(error)")
            }
        }
    }
    
    func loadMoreResults(searchTerm: String) {
        fetchSearchResults(searchTerm: searchTerm)
    }
    
    func clear() {
        self.searchItems.removeAll()
    }
}
