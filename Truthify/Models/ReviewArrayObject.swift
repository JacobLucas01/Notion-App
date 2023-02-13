//
//  ReviewArrayObject.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/14/23.
//

import SwiftUI
import Foundation
import AVFoundation

class ReviewArrayObject: ObservableObject {
    
    @Published var dataArray = [ReviewModel]()
    @Published var postCountString = "0"
    @Published var likeCountString = "0"
    
    init() {
        DataService.instance.downloadPostsForFeed { returnedPosts in
            let sortedPosts = returnedPosts.sorted { (post1, post2) in
                return post1.likeCount > post2.likeCount
            }
            self.dataArray.append(contentsOf: sortedPosts)
        }
    }
    
    init(reviewID: String) {
        DataService.instance.downloadIndividualReview(postID: reviewID) { review in
            self.dataArray.append(contentsOf: review)
        }
    }
    
    init(businessID: String) {
        //retrieve from cache if it exists, so use if in cache then return
        DataService.instance.downloadPostForBusiness(businessID: businessID) { (returnedPosts) in
            let sortedPosts = returnedPosts.sorted { (post1, post2) -> Bool in
                return post1.dateCreated > post2.dateCreated
            }
            self.dataArray.append(contentsOf: sortedPosts)
        }
    }
    
    init(userID: String) {
        DataService.instance.downloadPostForUser(userID: userID) { returnedPosts in
            let sortedPosts = returnedPosts.sorted { (post1, post2) -> Bool in
                return post1.dateCreated > post2.dateCreated
            }
            self.dataArray.append(contentsOf: sortedPosts)
            self.updateCounts()
        }
    }
    
    func updateCounts() {
        
        // post count
        self.postCountString = "\(self.dataArray.count)"
        
        // like count
        let likeCountArray = dataArray.map { (existingPost) -> Int in
            return existingPost.likeCount
        }
        let sumOfLikeCountArray = likeCountArray.reduce(0, +)
        self.likeCountString = "\(sumOfLikeCountArray)"
        
    }
}
