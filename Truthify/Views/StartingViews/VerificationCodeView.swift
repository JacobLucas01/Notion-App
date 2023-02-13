//
//  VerificationCodeView.swift
//  Truthify
//
//  Created by Jacob Lucas on 11/19/22.
//

import SwiftUI
import FirebaseAuth

struct VerificationCodeView: View {
    
    @State var verificationCode: String = ""
    @State var isLoading: Bool = false
    @State var isError: Bool = false
    
    @State var name: String = ""
    @State var username: String = ""
    @State var dateOfBirth: String = ""
    @State var providerID: String = ""
    @State var provider: String = "phone_authentication"
    @State var showCreateProfileView: Bool = false
    
    @State var showImagePicker: Bool = false
    @State var imageSelected: UIImage? = nil
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var closeView: Bool
    @Binding var phoneNumber: String
    
    @AppStorage("authVerificationID") var verificationID: String?
    
    var body: some View {
        ZStack {
            closeViewButton
            verifyCodeButton
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $isError) {
            Alert(title: Text("Wrong Code"), message: Text("The code entered is incorrect. Make sure the code is correct or hit 'Resend code' to recieve a new verification code."), dismissButton: .default(Text("OK")))
        }
        .fullScreenCover(isPresented: $showCreateProfileView) {
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
                        self.isLoading = false
                        self.showCreateProfileView.toggle()
                    } else {
                        print("Error getting provider ID from log in user to Firebase")
                        self.isError.toggle()
                        self.isLoading = false
                    }
                } else {
                    if let userID = returnedUserID {
                        AuthService.instance.logInUserToApp(userID: userID) { (success) in
                            if success {
                                print("Successful log in existing user")
                                self.isLoading = false
                                self.closeView.toggle()
                            } else {
                                print("Error logging existing user into our app")
                                self.isLoading = false
                                self.isError.toggle()
                            }
                        }
                    } else {
                        print("Error getting USER ID from existing user to Firebase")
                        self.isLoading = false
                        self.isError.toggle()
                    }
                }
            } else {
                print("Error getting info from log in user to Firebase")
                self.isLoading = false
                self.isError.toggle()
            }
        }
    }
    
    func verifyCode() {
        self.isLoading = true
        guard let verificationID = verificationID else { return }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        
        self.connectToFirebase(name: name, provider: provider, credential: credential)
    }
}

struct VerificationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationCodeView(closeView: .constant(true), phoneNumber: .constant("5099570981"))
    }
}

extension VerificationCodeView {
    
    var closeViewButton: some View {
        VStack(spacing: 0) {
            ZStack {
                VStack(spacing: 4) {
                    Text("Enter verification code")
                        .font(.system(size: 18, weight: .semibold))
                }
                HStack {
                    Button {
                        self.closeView.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title3)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
            }
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width - 30)
            Divider()
            Text("Your code was sent to +1\(phoneNumber).")
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .padding(.vertical, 12)
            Spacer()
        }
    }
    
    var verifyCodeButton: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .frame(height: 48)
                    .foregroundColor(Color(.systemGray3))
                TextField("Verification Code", text: $verificationCode)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .padding()
            }
            Button {
                self.verifyCode()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .frame(height: 48)
                        .foregroundColor(.accentColor)
                    if self.isLoading {
                        ProgressView()
                            .tint(Color.accentColor)
                    } else {
                        Text("Verify")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .buttonStyle(ButtonScaleStyle())
            VStack(spacing: 6) {
                Text("Didn't recieve a code?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                Button {
                    AuthService.instance.sendVerificationCode(phoneNumber: phoneNumber) { (success, error) in
                        if success {
                            print("Success resending code.")
                        } else {
                            self.isError = true
                            print("Error sending verification code.")
                        }
                    }
                } label: {
                    Text("Resend code")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.accentColor)
                }
            }
            .padding(.top, 15)
        }
        .frame(width: UIScreen.main.bounds.width - 30)
    }
    
}
