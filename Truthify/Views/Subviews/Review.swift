//
//  Review.swift
//  Truthify
//
//  Created by Jacob Lucas on 11/19/22.
//

import SwiftUI
import AVKit


struct Review: View {
    
    @State var review: ReviewModel
    @State private var reviewURL: URL?
    @State private var userProfileImage: UIImage? = nil
    @State var openComments: Bool = false
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if reviewURL != nil {
                FinalPreview(disableControls: false, player: AVPlayer(url: reviewURL!))
            } else {
                ProgressView()
                    .tint(.white)
            }
                VStack {
                    HStack(alignment: .top, spacing: 0) {
                        HStack {
                            Image(systemName: "person.fill")
                                .font(.system(size: 12))
                            Text("\(review.viewCount)")
                        }
                        .shadow(radius: 5)
                        Spacer()
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 30)
                    Spacer(minLength: 0)
                    HStack {
                        Spacer()
                        VStack(spacing: 25) {
                            Spacer()
                            Button {
                                if review.likedByUser {
                                    unlikePost()
                                } else {
                                    likePost()
                                }
                            } label: {
                                if review.likedByUser {
                                    Image(systemName: "hands.clap.fill")
                                        .foregroundColor(.accentColor)
                                        .font(.title)
                                } else {
                                    Image(systemName: "hands.clap.fill")
                                        .foregroundColor(.white)
                                        .font(.title)
                                }
                            }
                            .buttonStyle(ButtonScaleStyle())
                            NavigationLink {
                                LandmarkCommentView(review: review)
                            } label: {
                                Image(systemName: "arrowshape.turn.up.right.fill")
                                    .foregroundColor(.white)
                                    .font(.title)
                            }
                            .buttonStyle(ButtonScaleStyle())
                        }
                    }
                    .padding(.bottom)
                    .frame(width: UIScreen.main.bounds.width - 30)
                    HStack(spacing: 10) {
                        if let image = userProfileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 38, height: 38)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 38, height: 38)
                        }
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(review.username) • \(review.landmarkName) • " + (review.emojiRating == 0 ? "😡" : review.emojiRating == 1 ? "😭" : review.emojiRating == 2 ? "😐" : review.emojiRating == 3 ? "😁" : review.emojiRating == 4 ? "😍" : "😣"))
                                    .font(.system(size: 15, weight: .medium))
                                Text(review.caption)
                                    .font(.system(size: 14))
                                    .lineLimit(1)
                                    .padding(.trailing, 35)
                            }
                            Spacer(minLength: 0)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 30)
                }
                .padding(.vertical, 12)
                .foregroundColor(.white)
                .background {
                    VStack {
                        Spacer()
                        Rectangle()
                            .foregroundStyle(LinearGradient(colors: [Color(.black), .clear], startPoint: .bottom, endPoint: .top))
                            .frame(width: UIScreen.main.bounds.width, height: 100)
                    }
            }
        }
        .onAppear {
            if !review.viewedByUser {
                addView()
            }
            getVideo()
           getUserProfileImage()
        }
        .fullScreenCover(isPresented: $openComments) {
            LandmarkCommentView(review: review)
        }
    }
    
    func addView() {
        
        guard let userID = currentUserID else {
            print("Cannot find userID while liking post")
            return
        }
        
        let updatedReview = ReviewModel(postID: review.postID, userID: review.userID, username: review.username, caption: review.caption, emojiRating: review.emojiRating, dateCreated: review.dateCreated, landmarkName: review.landmarkName, viewCount: review.viewCount + 1, viewedByUser: true, likeCount: review.likeCount, likedByUser: true)
        self.review = updatedReview
        
        DataService.instance.addView(postID: review.postID, currentUserID: userID)

    }
    
    func getVideo() {
        VideoManager.instance.downloadVideo(postID: review.postID) { returnedURL in
            guard let url = returnedURL else { return }
            reviewURL = url
        }
    }
    
    func getUserProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: review.userID) { (returnedImage) in
            if let image = returnedImage {
                self.userProfileImage = image
            }
        }
    }
    
    func likePost() {
        
        HapticManager.notification(type: .success)
        
        guard let userID = currentUserID else {
            print("Cannot find userID while liking post")
            return
        }
        
        let updatedReview = ReviewModel(postID: review.postID, userID: review.userID, username: review.username, caption: review.caption, emojiRating: review.emojiRating, dateCreated: review.dateCreated, landmarkName: review.landmarkName, viewCount: review.viewCount, viewedByUser: review.viewedByUser, likeCount: review.likeCount + 1, likedByUser: true)
        self.review = updatedReview
        
        DataService.instance.likePost(postID: review.postID, currentUserID: userID)
        
    }
    
    func unlikePost() {
        
        HapticManager.notification(type: .success)
        
        guard let userID = currentUserID else {
            print("Cannot find userID while unliking post")
            return
        }
        
        let updatedReview = ReviewModel(postID: review.postID, userID: review.userID, username: review.username, caption: review.caption, emojiRating: review.emojiRating, dateCreated: review.dateCreated, landmarkName: review.landmarkName, viewCount: review.viewCount, viewedByUser: review.viewedByUser, likeCount: review.likeCount - 1, likedByUser: false)
        self.review = updatedReview

        DataService.instance.unlikePost(postID: review.postID, currentUserID: userID)
        
    }
}

struct Review_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Review(review: ReviewModel(postID: "", userID: "User5748503", username: "Jakey87", caption: "Here is a video of my experience. What do you think?", emojiRating: 0, dateCreated: Date(), landmarkName: "Mcdonalds", viewCount: 0, viewedByUser: false, likeCount: 0, likedByUser: false))
        }
    }
}
