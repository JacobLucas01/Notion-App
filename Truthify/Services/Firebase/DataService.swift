//
//  DataService.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/13/23.
//

import SwiftUI
import Foundation
import FirebaseFirestore

class DataService {

    
    static let instance = DataService()
    private var REF_POSTS = D_BASE.collection("posts")
    private var REF_USERS = D_BASE.collection("users")
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    func uploadPost(videoURL: URL, landmarkName: String, caption: String, emojiRating: Int, userID: String, businessID: String, username: String, handler: @escaping(_ success: Bool) -> ()) {
        
        let document = REF_POSTS.document()
        let postID = document.documentID
        
        VideoManager.instance.uploadVideo(postID: postID, video: videoURL) { (success) in
            if (success) {
                
                let postData: [String:Any] = [
                    "post_id" : postID,
                    "user_id" : userID,
                    "business_id": businessID,
                    "landmark_name": landmarkName,
                    "username" : username,
                    "caption" : caption,
                    "emoji_rating": emojiRating,
                    "date_created" : FieldValue.serverTimestamp()
                ]
                
                document.setData(postData) { (error) in
                    if let error = error {
                        print("Error uploading data to post document. \(error)")
                        handler(false)
                        return
                    } else {
                        handler(true)
                        self.incrementTotalUserReviews(reviewUserID: userID)
                        return
                    }
                }
            } else {
                handler(false)
            }
        }
    }
    
    func downloadPostsForFeed(handler: @escaping (_ posts: [ReviewModel]) -> ()) {
        REF_POSTS.getDocuments { (querySnapshot, error) in
            handler(self.getReviewsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    func downloadPostForUser(userID: String, handler: @escaping (_ posts: [ReviewModel]) -> ()) {
        REF_POSTS.whereField("user_id", isEqualTo: userID).getDocuments { (querySnapshot, error) in
            handler(self.getReviewsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    func downloadIndividualReview(postID: String, handler: @escaping (_ review: [ReviewModel]) -> ()) {
        REF_POSTS.whereField("post_id", isEqualTo: postID).getDocuments { (querySnapshot, error) in
            handler(self.getReviewsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    func downloadPostForBusiness(businessID: String, handler: @escaping (_ posts: [ReviewModel]) -> ()) {
        REF_POSTS.whereField("business_id", isEqualTo: businessID).getDocuments { (querySnapshot, error) in
            handler(self.getReviewsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    private func getReviewsFromSnapshot(querySnapshot: QuerySnapshot?) -> [ReviewModel] {
        var postArray = [ReviewModel]()
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            
            for document in snapshot.documents {
                if
                    let userID = document.get("user_id") as? String,
                    let username = document.get("username") as? String,
                    let caption = document.get("caption") as? String,
                    let emojiRating = document.get("emoji_rating") as? Int,
                    let landmarkName = document.get("landmark_name") as? String,
                    let timestamp = document.get("date_created") as? Timestamp {
                    let date = timestamp.dateValue()
                    let postID = document.documentID
                    let viewCount = document.get("view_count") as? Int ?? 0
                    let likeCount = document.get("like_count") as? Int ?? 0
                    var likedByUser: Bool = false
                    var viewedByUser: Bool = false
                    
                    if let userIDArray = document.get("viewed_by") as? [String], let userID = currentUserID {
                        viewedByUser = userIDArray.contains(userID)
                    }
                    
                    if let userIDArray = document.get("liked_by") as? [String], let userID = currentUserID {
                        likedByUser = userIDArray.contains(userID)
                    }
                    
                    let newPost = ReviewModel(postID: postID, userID: userID, username: username, caption: caption, emojiRating: emojiRating, dateCreated: date, landmarkName: landmarkName, viewCount: viewCount, viewedByUser: viewedByUser, likeCount: likeCount, likedByUser: likedByUser)
                    
                    postArray.append(newPost)
                }
            }
            return postArray
        } else {
            print("No documents in snapshot found for this user")
            return postArray
        }
    }
    
    func addView(postID: String, currentUserID: String) {
        
        let increment: Int64 = 1
        let data: [String:Any] = [
            "view_count" : FieldValue.increment(increment),
            "viewed_by" : FieldValue.arrayUnion([currentUserID])
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
    
    func likePost(postID: String, currentUserID: String) {
        
        let increment: Int64 = 1
        let data: [String:Any] = [
            "like_count" : FieldValue.increment(increment),
            "liked_by" : FieldValue.arrayUnion([currentUserID])
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }

    func unlikePost(postID: String, currentUserID: String) {
        
        let increment: Int64 = -1
        let data: [String:Any] = [
            "like_count" : FieldValue.increment(increment),
            "liked_by" : FieldValue.arrayRemove([currentUserID])
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
    
    func uploadComment(postID: String, content: String, username: String, reviewUserID: String, userID: String, handler: @escaping (_ success: Bool, _ commentID: String?) -> ()) {
        
        let document = REF_POSTS.document(postID).collection("comments").document()
        let commentID = document.documentID
        
        let data: [String:Any] = [
           "comment_id" : commentID,
           "user_id" : userID,
           "content" : content,
           "username" : username,
           "review_user_id": reviewUserID,
           "date_created" : FieldValue.serverTimestamp()
        ]
        
        document.setData(data) { (error) in
            if let error = error {
                print("Error uploading comment. \(error)")
                handler(false, nil)
                return
            } else {
                handler(true, commentID)
                self.createMessageNotification(reviewID: postID, comment: CommentModel(commentID: commentID, userID: userID, username: username, content: content, dateCreated: Date(), reviewUserID: reviewUserID))
                return
            }
        }
    }
    
    func downloadComments(postID: String, handler: @escaping (_ comments: [CommentModel]) -> ()) {
        REF_POSTS.document(postID).collection("comments").order(by: "date_created", descending: false).getDocuments { (querySnapshot, error) in
            handler(self.getCommentsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    private func getCommentsFromSnapshot(querySnapshot: QuerySnapshot?) -> [CommentModel] {
        var commentArray = [CommentModel]()
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            for document in snapshot.documents {
                if
                    let userID = document.get("user_id") as? String,
                    let displayName = document.get("username") as? String,
                    let content = document.get("content") as? String,
                    let reviewUserID = document.get("review_user_id") as? String,
                    let timestamp = document.get("date_created") as? Timestamp {
                    
                    let date = timestamp.dateValue()
                    let commentID = document.documentID
                    let newComment = CommentModel(commentID: commentID, userID: userID, username: displayName, content: content, dateCreated: date, reviewUserID: reviewUserID)
                    commentArray.append(newComment)
                }
            }
            return commentArray
        } else {
            print("No comments in document for this post")
            return commentArray
        }
    }
    
    func createMessageNotification(reviewID: String, comment: CommentModel) {
        
        let document = REF_USERS.document(comment.reviewUserID).collection("notifications").document()
        let notificationID = document.documentID
        
        let data: [String:Any] = [
            "notification_id": notificationID,
            "review_id" : reviewID,
            "is_opened" : false,
            "content" : comment.content,
            "username" : comment.username,
            "comment_user_id" : comment.userID,
            "date_created" : FieldValue.serverTimestamp()
        ]
        
        document.setData(data)
    }
    
    func updateNotificationView(notificationID: String, userID: String) {
        let document = REF_USERS.document(userID).collection("notifications").document(notificationID)
        
        document.delete { (error) in
            if let error = error {
                print("Error deleting document. ERROR: \(error)")
            }
        }
    }
    
    func incrementTotalUserReviews(reviewUserID: String) {
        
        let increment: Int64 = 1
        let data: [String:Any] = [
            "total_reviews" : FieldValue.increment(increment)
        ]
        
        REF_USERS.document(reviewUserID).updateData(data)
    }
    
    func incrementTotalUserLikes(reviewUserID: String) {
        
        let increment: Int64 = 1
        let data: [String:Any] = [
            "total_likes" : FieldValue.increment(increment)
        ]
        
        REF_USERS.document(reviewUserID).updateData(data)
    }
    
    func decrementTotalUserLikes(reviewUserID: String) {
        let increment: Int64 = -1
        let data: [String:Any] = [
            "total_likes" : FieldValue.increment(increment)
        ]
        
        REF_USERS.document(reviewUserID).updateData(data)
    }
    
    func getUserLikeCount(userID: String, handler: @escaping (_ likeCount: Double?) -> ()) {
        REF_USERS.document(userID).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot,
               let likeCount = document.get("total_likes") as? Double {
                handler(likeCount)
                return
            } else {
                print("Error getting user info")
                handler(nil)
                return
            }
        }
    }
    
    func getUserReviewCount(userID: String, handler: @escaping (_ reviewCount: Double?) -> ()) {
        REF_USERS.document(userID).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot,
               let reviewCount = document.get("total_reviews") as? Double {
                handler(reviewCount)
                return
            } else {
                print("Error getting user info")
                handler(nil)
                return
            }
        }
    }
    
    //func getUserInfo(forUserID userID: String, handler: @escaping (_ name: String?, _ username: String?) -> ()) {
    //    REF_USERS.document(userID).getDocument { (documentSnapshot, error) in
    //        if let document = documentSnapshot,
    //           let username = document.get(DatabaseUserField.username) as? String,
    //           let name = document.get(DatabaseUserField.name) as? String {
    //            print("Success getting user info")
    //            handler(name, username)
    //            return
    //        } else {
    //            print("Error getting user info")
    //            handler(nil, nil)
    //            return
    //        }
    //    }
    //}
    
    func updateDisplayNameOnPosts(userID: String, name: String) {
        downloadPostForUser(userID: userID) { (returnedPosts) in
            for post in returnedPosts {
                self.updatePostDisplayName(postID: post.postID, name: name)
            }
        }
    }

    private func updatePostDisplayName(postID: String, name: String) {

        let data: [String:Any] = [ "name" : name ]

        REF_POSTS.document(postID).updateData(data)
    }
    
    func updateUserUsername(userID: String, username: String, handler: @escaping (_ success: Bool) -> ()) {
        
        let data: [String:Any] = [
            "username" : username
        ]
        
        REF_USERS.document(userID).updateData(data) { (error) in
            if let error = error {
                print("Error updating user display name. \(error)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
        }
        
    }
}
