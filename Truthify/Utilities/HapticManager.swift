//
//  HapticManager.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/6/23.
//

import SwiftUI
import Foundation

class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
