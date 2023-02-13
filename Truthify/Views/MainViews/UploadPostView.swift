//
//  UploadPostView.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/8/23.
//

import SwiftUI
import AVKit
import CoreLocation

struct UploadPostView: View {
    
    let url: URL
    
    @State var searchBusinesses: String = ""
    @State var rating: Int = 3
    @State var description: String = ""
    @State var isLoading: Bool = false
    @State var emojiSelected: Int = 2
    @State var verified: Bool = false
    @State var landmarkLocation: String = ""
    @State var landmarkName: String = ""
    @State var openVerificationView: Bool = false
    
    @Binding var videoURL: URL?
    @Binding var isOpen: Bool
    
    @StateObject var vm = LocationViewModel()
    
    @AppStorage("user_id") var currentUserID: String?
    @AppStorage("username") var currentUsername: String?
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            title
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        search
                        addDescription
                    }
                    .padding(.top, 15)
                }
                Spacer()
                postButton
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            hideKeyboard()
        }
        .fullScreenCover(isPresented: $openVerificationView) {
            VerifyLandmarkView(verified: $verified, landmarkLocation: $landmarkLocation, landmarkName: $landmarkName, openVerificationView: $openVerificationView)
        }
    }
}

struct UploadPostView_Previews: PreviewProvider {
    static var previews: some View {
        UploadPostView(url: URL(string: "")!, landmarkLocation: "", videoURL: .constant(URL(fileURLWithPath: "url")), isOpen: .constant(false))
    }
}

extension UploadPostView {
    
    private var title: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Create Review")
                    .font(.system(size: 18, weight: .semibold))
                HStack {
                    Button {
                            self.dismiss.callAsFunction()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                    }
                    .buttonStyle(ButtonScaleStyle())
                    Spacer()
                }
            }
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width - 30)
            Divider()
        }
        .background(colorScheme == .dark ? .black : .white)
    }
    
    private var search: some View {
        HStack(spacing: 12) {
            FinalPreview(disableControls: true, player: AVPlayer(url: url))
                    .frame(width: 90, height: 160)
                    .mask {
                        RoundedRectangle(cornerRadius: 6)
                            .frame(height: 140)
                    }
                    .cornerRadius(6)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $description)
                if let text = String(description.filter { !" \n\t\r".contains($0) }), text == "" {
                    Text("What do you think?...")
                        .font(.system(size: 15))
                        .foregroundColor(Color(.systemGray2))
                        .padding(.trailing, 10)
                        .padding(.vertical, 10)
                        .padding(.leading, 6)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
    }
    
    private var addDescription: some View {
        VStack(spacing: 12) {
            HStack {
                Text("How are you feeling?")
                Image(systemName: "info.circle")
            }
            .padding(.top)
            .font(.system(size: 15))
            .foregroundColor(Color(.systemGray2))
            .cornerRadius(8)
            ZStack {
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            self.emojiSelected = 0
                        }
                    } label: {
                        Text("😡")
                            .frame(maxWidth: .infinity)
                            .opacity(emojiSelected == 0 ? 1.0 : 0.6)
                            .font(.system(size: emojiSelected == 0 ? 55 : 40))
                    }
                    Button {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            self.emojiSelected = 1
                        }
                    } label: {
                        Text("😭")
                            .frame(maxWidth: .infinity)
                            .opacity(emojiSelected == 1 ? 1.0 : 0.6)
                            .font(.system(size: emojiSelected == 1 ? 55 : 40))
                    }
                    Button {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            self.emojiSelected = 2
                        }
                    } label: {
                        Text("😐")
                            .frame(maxWidth: .infinity)
                            .opacity(emojiSelected == 2 ? 1.0 : 0.6)
                            .font(.system(size: emojiSelected == 2 ? 55 : 40))
                    }
                    Button {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            self.emojiSelected = 3
                        }
                    } label: {
                        Text("😁")
                            .frame(maxWidth: .infinity)
                            .opacity(emojiSelected == 3 ? 1.0 : 0.6)
                            .font(.system(size: emojiSelected == 3 ? 55 : 40))
                    }
                    Button {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            self.emojiSelected = 4
                        }
                    } label: {
                        Text("😍")
                            .frame(maxWidth: .infinity)
                            .opacity(emojiSelected == 4 ? 1.0 : 0.6)
                            .font(.system(size: emojiSelected == 4 ? 55 : 40))
                    }
                }
                .buttonStyle(ButtonScaleStyle())
            }
        }
        .navigationBarBackButtonHidden(true)
        .frame(width: UIScreen.main.bounds.width - 30)
    }
    
    private var postButton: some View {
        VStack(alignment: .trailing, spacing: 10) {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(Color(.systemGray2))
                Button {
                    openVerificationView.toggle()
                } label: {
                    HStack {
                        if verified {
                            Text("Verified")
                            Image(systemName: "checkmark.circle.fill")
                        } else {
                            Text("Verify Business")
                            Image(systemName: "location.fill")
                        }
                    }
                    .foregroundColor(verified ? .green : Color(.label))
                    .font(.system(size: 12))
                    .padding(10)
                    .background {
                        Color(.systemGray6)
                    }
                    .cornerRadius(8)
                }
            }
            VStack {
                Button {
                    self.isLoading = true
                    guard let userID = currentUserID, let username = currentUsername else { return }
                    DataService.instance.uploadPost(videoURL: url, landmarkName: landmarkName, caption: description, emojiRating: emojiSelected, userID: userID, businessID: landmarkLocation, username: username) { success in
                        print("Success")
                        self.isLoading = false
                        self.isOpen = false
                    }
                    self.isLoading = false
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 48)
                            .foregroundColor(.accentColor)
                        if !isLoading {
                            Text("Post Review")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                        } else {
                            ProgressView()
                                .tint(.white)
                        }
                    }
                }
                .buttonStyle(ButtonScaleStyle())
                .disabled(verified ? false : true)
                Text("Before posting, make sure your review follows Notion's guidelines here.")
                    .font(.system(size: 15))
                    .foregroundColor(Color(.systemGray2))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .lineSpacing(2)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
    }
}
