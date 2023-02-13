//
//  NotificationView.swift
//  Truthify
//
//  Created by Jacob Lucas on 11/21/22.
//

import SwiftUI
import FirebaseFirestore

struct NotificationView: View {
    
    @State var openReviewPreview: Bool = false
    
    @StateObject var viewModel: NotificationService
    @AppStorage("user_id") var currentUserID: String?
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Notifications")
                .font(.system(size: 18, weight: .semibold))
                .padding(.vertical)
            Divider()
            List {
                ForEach(viewModel.notificationArray) { notification in
                    Button {
                        openReviewPreview.toggle()
                    } label: {
                        Notification(notification: notification)
                    }
                    .fullScreenCover(isPresented: $openReviewPreview) {
                        NavigationView {
                            ReviewPreview(reviews: ReviewArrayObject(reviewID: notification.reviewID))
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .listStyle(PlainListStyle())
        }
    }
    
//    func updateNotification(notificationID: String) {
//        guard let userID = currentUserID else { return }
//        //   DataService.instance.updateNotificationView(notificationID: notificationID, userID: userID)
//    }
    
    func delete(at offsets: IndexSet) {
        guard let userID = currentUserID else { return }
        offsets.map { viewModel.notificationArray[$0] }.forEach { notification in
            D_BASE.collection("users").document(userID).collection("notifications").document(notification.notificationID).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    viewModel.newNotifications -= 1
                    print("Document successfully removed!")
                }
            }
        }
    }
    
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(viewModel: NotificationService())
    }
}
