//
//  NotificationCell.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/29/23.
//

import SwiftUI

struct Notification: View {
    
    var notification: NotificationModel
    @State var userProfileImage: UIImage? = nil
    
    var body: some View {
        VStack(spacing: 3) {
            HStack(alignment: .top, spacing: 18) {
                ZStack {
                    if let image = userProfileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 45, height: 45)
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Group {
                        Text(notification.username)
                            .fontWeight(.medium)
                        +
                        Text(" replied to your post ")
                            .foregroundColor(.gray)
                    }
                    Text(notification.content)
                        .lineLimit(1)
                        .padding(.trailing)
                    Text(notification.dateCreated.displayFormat)
                        .font(.system(size: 11))
                        .foregroundColor(Color(.systemGray))
                }
                .font(.system(size: 14))
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width - 30)
        }
        .onAppear {
            getUserProfileImage()
        }
    }
    
    func getUserProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: notification.commentUserID) { (returnedImage) in
            if let image = returnedImage {
                self.userProfileImage = image
            }
        }
    }
}

struct Notification_Previews: PreviewProvider {
    static var previews: some View {
        Notification(notification: NotificationModel(notificationID: "", commentUserID: "", reviewID: "", username: "Jacob_Lucas", content: "Hey ugly bitch, Queeeeeeeen Slayyyyyy", dateCreated: Date(), isOpened: false))
    }
}
