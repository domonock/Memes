//
//  Networking.swift
//  Memes
//
//  Created by Volodymyr Babych on 05.02.2024.
//

import Foundation
import Combine
class Networking {
    var cancellables = Set<AnyCancellable>()
    func fetchSearchResults(searchTerm: String, completion: @escaping (Result<NotPretySolution, Error>) -> Void) {
        guard let url = RedditURLConstructor.constructURL(searchTerm: searchTerm)  else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: RedditResponseModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionValue in
                switch completionValue {
                case .finished:
                    break
                case .failure(let error):
                    completion(.failure(error))
                }
            }, receiveValue: { result in
                let items = result.data.children.filter { $0.data.isVideo != true }
                let after = result.data.after
                let responce = NotPretySolution(post: items, afterID: after)
                completion(.success(responce))
            })
            .store(in: &cancellables)
    }
}

enum NetworkError: Error {
    case invalidURL
    case other(Error)
}

struct NotPretySolution {
    let post: [RedditPostModel]
    let afterID: String?
}

struct RedditURLConstructor {
    static let baseURL = "https://www.reddit.com/search.json"

    static func constructURL(searchTerm: String, subreddit: String = "memes", limit: Int = 50, sort: String = "top") -> URL? {
        var components = URLComponents(string: baseURL)
        let queryItems = [
            URLQueryItem(name: "q", value: "\(searchTerm) subreddit:\(subreddit)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "sort", value: sort)
        ]
        components?.queryItems = queryItems
        return components?.url
    }
}
