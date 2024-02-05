//
//  MessagesViewController.swift
//  MemesMessage
//
//  Created by Volodymyr Babych on 05.02.2024.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var collectionView: UICollectionView!
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let chache = ChacheManager()
    var searchItems = [RedditPostModel]()
    let networking = Networking()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        setupUI()
    }
    
    func setupUI() {
        layout.itemSize = CGSize(width: 150, height: 150) // Adjust based on your UI needs
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

