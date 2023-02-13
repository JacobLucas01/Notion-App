//
//  TruthifyApp.swift
//  Truthify
//
//  Created by Jacob Lucas on 11/17/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      print("\(#function)")
      Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      print("\(#function)")
      if Auth.auth().canHandleNotification(notification) {
        completionHandler(.noData)
        return
      }
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      print("\(#function)")
      if Auth.auth().canHandle(url) {
        return true
      }
      return false
    }
}

@main
struct TruthifyApp: App {
    
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
//    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    var body: some Scene {
        WindowGroup {
            if currentUserID != nil {
                NavigationView {
                    MainView()
                }
            } else {
                NavigationView {
                    OpeningView()
                }
            }
        }
    }
}
