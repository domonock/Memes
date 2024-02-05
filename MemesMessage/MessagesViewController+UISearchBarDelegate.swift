//
//  MessagesViewController+UISearchBarDelegate.swift
//  MemesMessage
//
//  Created by Volodymyr Babych on 05.02.2024.
//

import UIKit

extension MessagesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        chache.clear()
        if let searchText = searchBar.text {
            self.searchItems.removeAll()
            networking.fetchSearchResults(searchTerm: searchText) { [weak self] result in
                switch result {
                case .success(let responce):
                    if self?.searchItems.last != responce.post.last {
                        self?.searchItems += responce.post
                    }
                    self?.collectionView.reloadData()
                case .failure(let failure):
                    print(failure)
                }
            }
        }
        searchBar.resignFirstResponder()
    }
}
