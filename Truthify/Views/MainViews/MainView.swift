//
//  MainView.swift
//  Truthify
//
//  Created by Jacob Lucas on 11/19/22.
//

import SwiftUI

struct MainView: View {
    
    @State var newPost: Bool = false
    @State var viewSelection: String = "house"
    @ObservedObject var notification = NotificationService()
    @StateObject var reviews = ReviewArrayObject()
    
    @AppStorage("user_id") var currentUserID: String?
    
    var body: some View {
        VStack(spacing: 0) {
            switch viewSelection {
            case "house":
                FeedView(reviews: reviews)
            case "bell":
                NotificationView(viewModel: notification)
            case "person.crop.circle":
                if let userID = currentUserID {
                    ProfileView(reviewArray: ReviewArrayObject(userID: userID))
                }
            default:
                Text("Error")
            }
            Menu(numOfNotifications: $notification.newNotifications, viewSelection: $viewSelection, newPost: $newPost)
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .fullScreenCover(isPresented: $newPost) {
            NavigationView {
                PostView(isOpen: $newPost)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().preferredColorScheme(.dark)
    }
}
