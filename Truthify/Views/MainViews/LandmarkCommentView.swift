//
//  PostCommentView.swift
//  Truthify
//
//  Created by Jacob Lucas on 12/26/22.
//

import SwiftUI

struct LandmarkCommentView: View {
    
    var review: ReviewModel
    
    @State var message: String = ""
    @State var commentArray = [CommentModel]()
    
    @AppStorage("user_id") var currentUserID: String?
    @AppStorage("username") var currentUsername: String?
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollViewReader { value in
            VStack(spacing: 0) {
                ZStack {
                    Text("Replies")
                        .font(.system(size: 18, weight: .semibold))
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
                }
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 30)
                .background {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width)
                        .edgesIgnoringSafeArea(.top)
                        .foregroundColor(colorScheme == .light ? .white : .black)
                }
                Divider()
                ScrollView(showsIndicators: false) {
                    ForEach(commentArray, id: \.id) { comment in
                        Message(comment: comment).id(comment)
                    }
                    .frame(width: UIScreen.main.bounds.width - 30)
                }
                Divider()
                HStack {
                    ZStack(alignment: .trailing) {
                        RoundedRectangle(cornerRadius: .infinity)
                            .stroke(lineWidth: 1)
                            .frame(height: 44)
                            .foregroundColor(Color(.systemGray3))
                        HStack {
                            TextField("Type a message", text: $message)
                            Button(action: {
                                addComment()
                                withAnimation {
                                    value.scrollTo(commentArray.last, anchor: .top)
                                }
                            }, label: {
                                Image(systemName: "paperplane.circle.fill")
                                    .font(.title)
                            })
                            .foregroundColor(.accentColor)
                        }
                        .padding(.horizontal, 8)
                        .padding(.leading, 6)
                    }
                }
                .padding()
                .background {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width)
                        .edgesIgnoringSafeArea(.top)
                        .foregroundColor(colorScheme == .light ? .white : .black)
                }
            }
            .onAppear {
                getComments()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func getComments() {
        guard self.commentArray.isEmpty else { return }
        
        if review.caption.count > 1 {
            let captionComment = CommentModel(commentID: "", userID: review.userID, username: review.username, content: review.caption, dateCreated: review.dateCreated, reviewUserID: "")
            self.commentArray.append(captionComment)
        }
        
        DataService.instance.downloadComments(postID: review.postID) { (returnedComments) in
            self.commentArray.append(contentsOf: returnedComments)
        }
    }
    
    func addComment() {
        
        guard let userID = currentUserID else { return }
        guard let username = currentUsername else { return }
        
        DataService.instance.uploadComment(postID: review.postID, content: message, username: username, reviewUserID: review.userID, userID: userID) { (success, returnedCommentID) in
            if success, let commentID = returnedCommentID {
                let newComment = CommentModel(commentID: commentID, userID: userID, username: username, content: message, dateCreated: Date(), reviewUserID: review.userID)
                self.commentArray.append(newComment)
                self.message = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        
    }
}

struct LandmarkCommentView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkCommentView(review: ReviewModel(postID: "", userID: "", username: "", caption: "", emojiRating: 0, dateCreated: Date(), landmarkName: "", viewCount: 0, viewedByUser: false, likeCount: 0, likedByUser: false))
    }
}

