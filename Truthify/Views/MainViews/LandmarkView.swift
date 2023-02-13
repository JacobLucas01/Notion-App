//
//  BusinessPageView.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/14/23.
//

import SwiftUI
import MapKit

struct LandmarkView: View {
    
    var posts: ReviewArrayObject
    var landmarkName: String
    var landmarkAddress: String
    @State var isPressed: Bool = false
    @State var offset: CGSize = .zero
    @State private var currentPage = 0
    @State var transition: AnyTransition = .identity
    @Binding var openComments: Bool
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                        Text(landmarkName)
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .medium))
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            .padding(.vertical, 6)
            .frame(width: UIScreen.main.bounds.width - 30)
            ZStack {
                GeometryReader { proxy in
                    TabView {
                        ForEach(posts.dataArray, id: \.self) { review in
                            ZStack {
                                Review(review: review)
                                    .frame(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 1.25)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .clipped()
                            }
                            .sheet(isPresented: $openComments) {
                                LandmarkCommentView(review: review)
                            }
                        }
                        .rotationEffect(.degrees(-90))
                        .frame(
                            width: proxy.size.width,
                            height: proxy.size.height
                        )
                    }
                    .rotationEffect(.degrees(90), anchor: .topLeading)
                    .offset(x: proxy.size.width) 
                    .tabViewStyle(
                        PageTabViewStyle(indexDisplayMode: .never)
                    )
                    .frame(width: proxy.size.height, height: proxy.size.width)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LandmarkView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkView(posts: ReviewArrayObject(businessID: ""), landmarkName: "Chick Fil A", landmarkAddress: "North Spokane St", openComments: .constant(false))
    }
}
