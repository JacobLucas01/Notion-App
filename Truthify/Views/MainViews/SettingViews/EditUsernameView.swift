//
//  EditUsernameView.swift
//  Truthify
//
//  Created by Jacob Lucas on 2/11/23.
//

import SwiftUI

struct EditUsernameView: View {
    
    @State var updatedUsername: String = ""
    @State var username: String
    @State var showSuccessAlert: Bool = false
    
    @AppStorage("user_id") var currentUserID: String?
    
    @Environment(\.presentationMode) var presentationMode
    
    let haptics = UINotificationFeedbackGenerator()
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                            Text("Profile")
                        }
                        .foregroundColor(Color(.label))
                    }
                    Spacer()
                }
                Text("Edit Username")
                    .font(.system(size: 18, weight: .semibold))
            }
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width - 30)
            Form {
                Section {
                    HStack {
                        Spacer()
                        Text(username)
                            .font(.title)
                            .fontWeight(.medium)
                        Spacer()
                    }
                }
                .listRowBackground(Color(UIColor.systemGroupedBackground))
                Section {
                    ZStack {
                        TextField("Enter new name", text: $updatedUsername)
                            .multilineTextAlignment(TextAlignment.center)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                    }
                    HStack {
                        Spacer()
                    Button {
                        if textIsAppropriate() {
                            saveText()
                        }
                    } label: {
                        Text("Update Name")
                            .foregroundColor(Color(.label))
                    }
                        Spacer()
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .alert(isPresented: $showSuccessAlert) { () -> Alert in
            return Alert(title: Text("Saved Successfully"), message: nil, dismissButton: .default(Text("OK"), action: {
                dismissView()
            }))
        }
    }
    func dismissView() {
        self.haptics.notificationOccurred(.success)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func textIsAppropriate() -> Bool {

        let badWordArray: [String] = ["shit", "ass"]
        
        let words = updatedUsername.components(separatedBy: " ")
        
        for word in words {
            if badWordArray.contains(word) {
                return false
            }
        }
        
        if updatedUsername.count < 3 {
            return false
        }
        
        return true
    }
    
    func saveText() {
        guard let userID = currentUserID else { return }
        
        // Update the UI
        self.username = updatedUsername
        
        // Update user defaults
        UserDefaults.standard.setValue(updatedUsername, forKey: "username")
        
        // Update on all user's profile in DB
        AuthService.instance.updateUserUsername(userID: userID, username: updatedUsername) { success in
            self.showSuccessAlert.toggle()
        }
    }
}

struct EditUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        EditUsernameView(username: "")
    }
}
