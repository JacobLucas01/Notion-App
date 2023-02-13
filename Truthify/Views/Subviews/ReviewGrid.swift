//
//  ReviewGridView.swift
//  Truthify
//
//  Created by Jacob Lucas on 11/21/22.
//

import SwiftUI
import AVFoundation

struct ReviewGrid: View {

    @StateObject var reviews: ReviewArrayObject
    @Binding var openFullScreenReview: Bool
    
    var layout = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]
    
    var body: some View {
            LazyVGrid(columns: layout, spacing: 0) {
                ForEach(reviews.dataArray, id: \.self) { review in
                    Button {
                        openFullScreenReview.toggle()
                    } label: {
                        ReviewGridPreview(review: review)
                                .clipShape(Rectangle())
                                .clipped()
                                .frame(width: UIScreen.main.bounds.width / 3, height: 200)
                              //  .allowsHitTesting(false)
                    }
                    .buttonStyle(ButtonScaleStyle())
                    .fullScreenCover(isPresented: $openFullScreenReview, content: {
                        LandmarkView(posts: ReviewArrayObject(reviewID: review.postID), landmarkName: review.landmarkName, landmarkAddress: "", openComments: .constant(false))
                    })
                }
            }
    }
}

struct ReviewGrid_Previews: PreviewProvider {
    static var previews: some View {
        ReviewGrid(reviews: ReviewArrayObject(), openFullScreenReview: .constant(false))
    }
}
