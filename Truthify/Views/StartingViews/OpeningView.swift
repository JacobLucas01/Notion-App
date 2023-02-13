//
//  OpeningView.swift
//  Truthify
//
//  Created by Jacob Lucas on 11/18/22.
//

import SwiftUI
import FirebaseAuth
import AuthenticationServices

struct OpeningView: View {
    
    @State var name: String = ""
    @State var username: String = ""
    @State var dateOfBirth: String = ""
    @State var provider: String = ""
    @State var providerID: String = ""
    
    @State var isLoading: Bool = false
    @State var isError: Bool = false
    @State var showAccountCreation: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.accentColor.ignoresSafeArea()
            logo
            mainButtons
        }
        .navigationBarBackButtonHidden(true)
        .foregroundColor(.white)
        .fullScreenCover(isPresented: $showAccountCreation) {
            CreateAccountView(name: $name, username: $username, dateOfBirth: $dateOfBirth, provider: $provider, providerID: $providerID)
        }
    }
    
    func connectToFirebase(name: String, provider: String, credential: AuthCredential) {
        AuthService.instance.logInUserToFirebase(credential: credential) { (returnedProviderID, isError, isNewUser, returnedUserID)  in
            if let newUser = isNewUser {
                if newUser {
                    if let providerID = returnedProviderID, !isError {
                        self.name = name
                        self.providerID = providerID
                        self.provider = provider
                        self.showAccountCreation.toggle()
                    } else {
                        print("Error getting provider ID from log in user to Firebase")
                        self.isError.toggle()
                    }
                } else {
                    if let userID = returnedUserID {
                        AuthService.instance.logInUserToApp(userID: userID) { (success) in
                            if success {
                                print("Successful log in existing user")
                                self.dismiss()
                            } else {
                                print("Error logging existing user into our app")
                                self.isError.toggle()
                            }
                        }
                    } else {
                        print("Error getting USER ID from existing user to Firebase")
                        self.isError.toggle()
                    }
                }
            } else {
                print("Error getting into from log in user to Firebase")
                self.isError.toggle()
            }
        }
    }
}

struct OpeningView_Previews: PreviewProvider {
    static var previews: some View {
        OpeningView().preferredColorScheme(.dark)
    }
}

extension OpeningView {
    
    var logo: some View {
        Text("Notion")
            .font(.system(size: 34, weight: .medium))
            .padding(.bottom, 50)
    }
    
    var mainButtons: some View {
        VStack(spacing: 10) {
            Spacer()
            NavigationLink {
                PhoneAuthView()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .frame(height: 48)
                    Text("Continue with Phone")
                        .font(.system(size: 18, weight: .semibold))
                }
            }
            .buttonStyle(ButtonScaleStyle())
            Button {
                SignInWithApple.instance.startSignInWithAppleFlow(view: self)
            } label: {
                SignInWithAppleButton()
                    .frame(height: 48)
                    .cornerRadius(8)
            }
            .buttonStyle(ButtonScaleStyle())
            Text("By continuing, you are agreeing to Notion's Terms of Service and Privacy Policy.")
                .multilineTextAlignment(.center)
                .font(.system(size: 15))
                .padding(12)
                .lineSpacing(2)
        }
        .frame(width: UIScreen.main.bounds.width - 30)
    }
    
}
