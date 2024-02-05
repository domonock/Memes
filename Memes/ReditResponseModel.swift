//
//  ReditResponseModel.swift
//  Memes
//
//  Created by Volodymyr Babych on 13.12.2023.
//

import Foundation

import Foundation

// Define the top-level response model
struct RedditResponseModel: Codable, Equatable {
    static func == (lhs: RedditResponseModel, rhs: RedditResponseModel) -> Bool {
        return lhs.data.children == rhs.data.children
    }
    
    let kind: String
    let data: RedditDataModel
}

// Define the data model containing search results and pagination info
struct RedditDataModel: Codable {
    let modhash: String?
    let dist: Int?
    let children: [RedditPostModel]
    let after: String?
    let before: String?
}

// Define the model for individual posts
struct RedditPostModel: Codable, Equatable {
    let kind: String
    let data: PostData
}

// Define the detailed model for the content of individual posts
struct PostData: Codable, Equatable {
    let subreddit: String
    let selftext: String?
    let author: String
    let title: String
    let upvoteRatio: Double?
    let ups: Int?
    let downs: Int?
    let numComments: Int?
    let created: Double?
    let createdUtc: Double?
    let thumbnail: String?
    let url: String?
    let permalink: String?
    let isVideo: Bool?
    
    // Add any additional fields you need
    
    // Coding keys to map JSON keys that don't match Swift naming conventions
    private enum CodingKeys: String, CodingKey {
        case subreddit, selftext, author, title
        case upvoteRatio = "upvote_ratio"
        case ups, downs
        case numComments = "num_comments"
        case created, createdUtc = "created_utc"
        case thumbnail, url, permalink
        case isVideo = "is_video"
    }
}

