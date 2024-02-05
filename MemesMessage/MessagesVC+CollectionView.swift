//
//  MessagesVC+CollectionView.swift
//  MemesMessage
//
//  Created by Volodymyr Babych on 05.02.2024.
//

import Messages
import UIKit

extension MessagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell,
              let urlString = searchItems[indexPath.row].data.url,
              let url = URL(string: urlString) else {
            return UICollectionViewCell()
        }
        chache.fillImage(from: url, completion: { image in
            cell.imageView.image = image
        })
        return cell
    }
}

extension MessagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let conversation = activeConversation else { return }
        if let imageUrl = self.searchItems[indexPath.row].data.url {
            chache.fillImage(from: URL(string: imageUrl)!) { image in
                let message = MSMessage()
                let layout = MSMessageTemplateLayout()
                layout.image = image
                message.layout = layout
                conversation.insert(message)
            }
        }
    }
}
