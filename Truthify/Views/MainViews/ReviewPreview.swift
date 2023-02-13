//
//  ReviewPreview.swift
//  Truthify
//
//  Created by Jacob Lucas on 2/5/23.
//

import SwiftUI

struct ReviewPreview: View {
    
    @StateObject var reviews: ReviewArrayObject
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    self.dismiss.callAsFunction()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width - 30)
            ForEach(reviews.dataArray, id: \.self) { review in
                Review(review: review)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .clipped()
            }
        }
        .navigationBarBackButtonHidden(true)

    }
}

struct ReviewPreview_Previews: PreviewProvider {
    static var previews: some View {
        ReviewPreview(reviews: ReviewArrayObject())
    }
}
