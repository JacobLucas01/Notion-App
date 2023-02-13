//
//  ReviewModel.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/14/23.
//

import Foundation

struct ReviewModel: Identifiable, Hashable {
    
    var id = UUID()
    var postID: String
    var userID: String
    var username: String
    var caption: String
    var emojiRating: Int
    var dateCreated: Date
    var landmarkName: String
    var viewCount: Int
    var viewedByUser: Bool
    var likeCount: Int
    var likedByUser: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
