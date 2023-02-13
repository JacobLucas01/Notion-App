//
//  ReviewGridPreview.swift
//  Truthify
//
//  Created by Jacob Lucas on 2/4/23.
//

import SwiftUI
import AVKit

struct ReviewGridPreview: View {
    
    @State var review: ReviewModel
    @State private var reviewURL: URL?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if reviewURL != nil {
                    ZStack(alignment: .bottomLeading) {
                        FinalPreview(disableControls: true, player: AVPlayer(url: reviewURL!))
                        HStack(spacing: 4) {
                            Image(systemName: "person.fill")
                            Text("\(review.viewCount)")
                        }
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                        .padding(4)
                }
            } else {
                ProgressView()
                    .tint(.white)
            }
        }
        .onAppear {
            getVideo()
        }
    }
    
    func getVideo() {
        VideoManager.instance.downloadVideo(postID: review.postID) { (returnedURL) in
            guard let url = returnedURL else { return }
            reviewURL = url
        }
    }
}

struct ReviewGridPreview_Previews: PreviewProvider {
    static var previews: some View {
        ReviewGridPreview(review: ReviewModel(postID: "", userID: "", username: "", caption: "", emojiRating: 0, dateCreated: Date(), landmarkName: "", viewCount: 0, viewedByUser: false, likeCount: 0, likedByUser: false))
    }
}
