//
//  AuthService.swift
//  Truthify
//
//  Created by Jacob Lucas on 12/28/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

let D_BASE = Firestore.firestore()

class AuthService {
    
    static let instance = AuthService()
    
    private var REF_USERS = D_BASE.collection("users")
    
    func logInUserToFirebase(credential: AuthCredential, handler: @escaping (_ providerID: String?, _ isError: Bool, _ isNewUser: Bool?, _ userID: String?) -> ()) {
        Auth.auth().signIn(with: credential) { (result, error) in
            
            if error != nil {
                print("Error logging in to Firebase")
                handler(nil, true, nil, nil)
                return
            }
            
            guard let providerID = result?.user.uid else {
                print("Error getting provider ID")
                handler(nil, true, nil, nil)
                return
            }
            
            self.checkIfUserExistsInDatabase(providerID: providerID) { (returnedUserID) in
                if let userID = returnedUserID {
                    handler(providerID, false, false, userID)
                } else {
                    handler(providerID, false, true, nil)
                }
            }
            
        }
    }
    
    private func checkIfUserExistsInDatabase(providerID: String, handler: @escaping (_ existingUserID: String?) -> ()) {
        REF_USERS.whereField(DatabaseUserField.providerID, isEqualTo: providerID).getDocuments { (querySnapshot, error) in
            if let snapshot = querySnapshot, snapshot.count > 0, let document = snapshot.documents.first {
                let existingUserID = document.documentID
                handler(existingUserID)
                return
            } else {
                handler(nil)
                return
            }
        }
    }
    
    func logInUserToApp(userID: String, handler: @escaping (_ success: Bool) -> ()) {
        getUserInfo(forUserID: userID) { (returnedName, returnedUsername) in
            if let name = returnedName, let username = returnedUsername {
                print("Success getting user info while logging in")
                handler(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    UserDefaults.standard.set(userID, forKey: CurrentUserDefaults.userID)
                    UserDefaults.standard.set(name, forKey: CurrentUserDefaults.name)
                    UserDefaults.standard.set(username, forKey: CurrentUserDefaults.username)
                }
            } else {
                print("Error getting user info while logging in")
                handler(false)
            }
        }
    }
    
    func getUserInfo(forUserID userID: String, handler: @escaping (_ name: String?, _ username: String?) -> ()) {
        REF_USERS.document(userID).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot,
               let username = document.get(DatabaseUserField.username) as? String,
               let name = document.get(DatabaseUserField.name) as? String {
                print("Success getting user info")
                handler(name, username)
                return
            } else {
                print("Error getting user info")
                handler(nil, nil)
                return
            }
        }
    }
    
    func createNewUserInDatabase(name: String, username: String, dateOfBirth: String, providerID: String, provider: String, profileImage: UIImage, handler: @escaping (_ userID: String?) -> ()) {

        let document = REF_USERS.document()
        let userID = document.documentID
        
        ImageManager.instance.uploadProfileImage(userID: userID, image: profileImage)
        
        let userData: [String: Any] = [
            DatabaseUserField.name : name,
            DatabaseUserField.username : username,
            DatabaseUserField.dateOfBirth : dateOfBirth,
            DatabaseUserField.providerID : providerID,
            DatabaseUserField.provider : provider,
            DatabaseUserField.userID : userID,
            DatabaseUserField.dateCreated : FieldValue.serverTimestamp(),
        ]
        
        document.setData(userData) { (error) in
            if let error = error {
                print("Error uploading data to user document. \(error)")
                handler(nil)
            } else {
                handler(userID)
            }
            
        }
        
    }
    
    func logOutUser(handler: @escaping (_ success: Bool) ->  ()) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error \(error)")
            handler(false)
            return
        }
        
        handler(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
            defaultsDictionary.keys.forEach { (key) in
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
    
    func sendVerificationCode(phoneNumber: String, handler: @escaping (_ success: Bool, _ error: Bool) -> ()) {
        PhoneAuthProvider.provider().verifyPhoneNumber("+1" + phoneNumber, uiDelegate: nil) { (verificationID, error) in
            
            if let error = error {
                print("Error sending user phone number to Firebase. \(error)")
                handler(false, true)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            handler(true, false)
        }
    }
    
    func updateUserDisplayName(userID: String, name: String, handler: @escaping (_ success: Bool) -> ()) {
        
        let data: [String:Any] = [ "name" : name ]
        
        REF_USERS.document(userID).updateData(data) { (error) in
            if let error = error {
                print("Error updating user display name. \(error)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
        }
    }
    
    func updateUserUsername(userID: String, username: String, handler: @escaping (_ success: Bool) -> ()) {
        
        let data: [String:Any] = [ "username" : username ]
        
        REF_USERS.document(userID).updateData(data) { (error) in
            if let error = error {
                print("Error updating user display name. \(error)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
        }
    }
}
