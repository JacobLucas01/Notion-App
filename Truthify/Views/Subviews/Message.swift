//
//  MessageView.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/28/23.
//

import SwiftUI

struct Message: View {
    
    @State var comment: CommentModel
    @State var userProfileImage: UIImage? = nil
    
    static let stackDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss z"
        return formatter
    }()
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            if let image = userProfileImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 34, height: 34)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 34, height: 34)
            }
            VStack(alignment: .leading, spacing: 4, content: {
                Text(comment.username)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                VStack(alignment: .leading, spacing: 2) {
                    Text(comment.content)
                        .font(.system(size: 15))
                        .foregroundColor(.primary)
                    if comment.dateCreated.date == Date().date {
                        Text("Today at " + comment.dateCreated.displayFormat)
                    } else if comment.dateCreated.date == Calendar.current.date(byAdding: .day, value: -1, to: Date())!.date  {
                        Text("Yesterday at " + comment.dateCreated.displayFormat)
                    } else {
                        Text(comment.dateCreated.displayFormat2)
                    }
                }
                .padding(.all, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .foregroundColor(Color(.systemGray3))
                )
                .font(.system(size: 10))
                .foregroundColor(.gray)
                .padding(.trailing)
            })
            Spacer(minLength: 0)
        }
        .padding(.top, 12)
        .onAppear {
            getUserProfileImage()
        }
    }
    
    func getUserProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: comment.userID) { (returnedImage) in
            if let image = returnedImage {
                self.userProfileImage = image
            }
        }
    }
}

struct Message_Previews: PreviewProvider {
    static var previews: some View {
        Message(comment: CommentModel(commentID: "", userID: "", username: "Jake_Lucas", content: "Hey whats up? I really like this review, nice job! Best Buy does suck balls!", dateCreated: Date(), reviewUserID: ""))
    }
}

extension Date {
    var displayFormat: String {
        self.formatted(
            .dateTime
                .hour()
                .minute()
        )
    }
    
    var displayFormat2: String {
        self.formatted(
            .dateTime
                .year()
                .month()
                .day()
        )
    }
    
    var date: String {
        self.formatted(
            .dateTime
                .day()
                .month()
                .year()
        )
    }
}
