//
//  NotificationModel.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/29/23.
//

import Foundation

struct NotificationModel: Identifiable, Hashable {
    
    var id = UUID()
    var notificationID: String
    var commentUserID: String
    var reviewID: String
    var username: String
    var content: String
    var dateCreated: Date
    var isOpened: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
