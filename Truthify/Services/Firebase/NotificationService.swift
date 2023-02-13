//
//  NotificationService.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/29/23.
//

import SwiftUI
import FirebaseFirestore
import Foundation

class NotificationService: ObservableObject {
    
    init() {
        getNotifications()
    }
    
    private var REF_USERS = D_BASE.collection("users")
    @AppStorage("user_id") var currentUserID: String?
    @Published var notificationArray = [NotificationModel]()
    @Published var newNotifications: Int = 0
    
    func getNotifications() {
        newNotifications = 0
        guard let userID = currentUserID else { return }
        
        REF_USERS.document(userID).collection("notifications").addSnapshotListener { snapshot, error in
            
            guard let document = snapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
            }
            self.newNotifications = document.count
            
            self.notificationArray = document.map { snapshot -> NotificationModel in
                let data = snapshot.data()
                let commentUserID = data["comment_user_id"] as? String ?? ""
                let isOpen = data["is_open"] as? Bool ?? false
                let content = data["content"] as? String ?? ""
                let reviewID = data["review_id"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let dateCreated = data["date_created"] as? Timestamp
                let notificationID = data["notification_id"] as? String ?? ""
                
                
                return NotificationModel(notificationID: notificationID, commentUserID: commentUserID, reviewID: reviewID, username: username, content: content, dateCreated: dateCreated?.dateValue() ?? Date(), isOpened: isOpen)
            }
            
        }
    }
}
