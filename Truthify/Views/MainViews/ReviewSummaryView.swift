//
//  ReviewSummaryView.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/29/23.
//

import SwiftUI

struct ReviewSummaryView: View {
    var reviewArray: ReviewArrayObject
    var body: some View {
        ForEach(reviewArray.dataArray, id: \.self) { review in
            VStack(spacing: 0) {
                LandmarkCommentView(review: review)
            }
        }
    }
}

struct ReviewSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewSummaryView(reviewArray: ReviewArrayObject())
    }
}
