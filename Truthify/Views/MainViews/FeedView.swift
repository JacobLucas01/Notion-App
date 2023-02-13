//
//  HomeView.swift
//  Truthify
//
//  Created by Jacob Lucas on 11/19/22.
//

import SwiftUI

struct FeedView: View {
    
    @StateObject var reviews: ReviewArrayObject
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            GeometryReader { proxy in
                    TabView {
                        ForEach(reviews.dataArray, id: \.self) { review in
                            VStack(spacing: 0) {
                                Review(review: review)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .clipped()
                            }
                        }
                        .rotationEffect(.degrees(-90))
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .ignoresSafeArea()
                    }
                    .rotationEffect(.degrees(90), anchor: .topLeading)
                    .offset(x: proxy.size.width)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(width: proxy.size.height, height: proxy.size.width)
            }
            VStack {
                HStack {
                    Spacer()
                    NavigationLink {
                        SearchView()
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 20, height: 20)
                                .opacity(0.0)
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.white)
                                .shadow(radius: 5)
                        }
                        .padding(.top, 12)
                    }
                    .buttonStyle(ButtonScaleStyle())
                }
                .frame(width: UIScreen.main.bounds.width - 30)
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeedView(reviews: ReviewArrayObject()).preferredColorScheme(.dark)
        }
    }
}
