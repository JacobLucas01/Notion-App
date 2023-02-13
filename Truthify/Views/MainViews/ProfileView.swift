//
//  ProfileView.swift
//  Truthify
//
//  Created by Jacob Lucas on 11/21/22.
//

import SwiftUI

struct ProfileView: View {
    
    @State var info: Bool = false
    @State var currentUserProfileImage: UIImage? = nil
    @State var openFullScreenReview: Bool = false
    
    @ObservedObject var reviewArray: ReviewArrayObject
    
    @AppStorage("name") var name: String?
    @AppStorage("username") var username: String?
    @AppStorage("date_of_birth") var dateOfBirth: String?
    @AppStorage("user_id") var currentUserID: String?
    
    var body: some View {
        VStack(spacing: 0) {
            viewHeading
            Divider()
            ScrollView(showsIndicators: false) {
                userStatistics
                grid
            }
        }
        .onAppear {
            getCurrentUserProfileImage()
        }
    }
    
    func getCurrentUserProfileImage() {
        guard let userID = currentUserID else { return }
        ImageManager.instance.downloadProfileImage(userID: userID) { (returnedImage) in
            if let image = returnedImage {
                self.currentUserProfileImage = image
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(reviewArray: ReviewArrayObject())
    }
}

extension ProfileView {
    
    var viewHeading: some View {
        ZStack {
            Text("@" + (username ?? ""))
                .font(.system(size: 18, weight: .semibold))
            HStack {
                Spacer()
                NavigationLink {
                  
                        SettingsView(profileImage: $currentUserProfileImage)
                    
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title3)
                }
                .buttonStyle(ButtonScaleStyle())
            }
        }
        .padding(.vertical)
        .frame(width: UIScreen.main.bounds.width - 30)
    }
    
    var userStatistics: some View {
        HStack {
            ZStack(alignment: .top) {
                if let image = currentUserProfileImage  {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color(.systemGray4))
                }
            }
            VStack {
                HStack {
                    VStack(spacing: 1) {
                        Text(reviewArray.postCountString)
                        Text("Reviews")
                    }
                    .frame(maxWidth: .infinity)
                    VStack(spacing: 1) {
                        Text("0")
                        Text("Saved")
                    }
                    .frame(maxWidth: .infinity)
                    VStack(spacing: 1) {
                        Text(reviewArray.likeCountString)
                        Text("Likes")
                    }
                    .frame(maxWidth: .infinity)
                }
                .font(.system(size: 13))
                .foregroundColor(Color(.systemGray))
            }
            Spacer()
        }
        .padding(.vertical)
        .frame(width: UIScreen.main.bounds.width - 30)
    }
    
    var grid: some View {
        ReviewGrid(reviews: reviewArray, openFullScreenReview: $openFullScreenReview)
    }
    
}

