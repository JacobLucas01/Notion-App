//
//  CreateAccountView.swift
//  Truthify
//
//  Created by Jacob Lucas on 11/19/22.
//

import SwiftUI

struct CreateAccountView: View {
    
    @Binding var name: String
    @Binding var username: String
    @Binding var dateOfBirth: String
    @Binding var provider: String
    @Binding var providerID: String
    
    @State var imageSelected: UIImage? = nil
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var showImagePicker: Bool = false
    
    @State var imagePicker: Bool = false
    @State var isError: Bool = false
    @State var isLoading: Bool = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            addDetails
            title
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(imageSelected: $imageSelected, sourceType: $sourceType)
        }
    }
    
    func createProfile() {
        isLoading.toggle()
        guard let imageSelected = imageSelected else { return }
        AuthService.instance.createNewUserInDatabase(name: name, username: username, dateOfBirth: dateOfBirth, providerID: providerID, provider: provider, profileImage: imageSelected) { (returnedUserID) in
            if let userID = returnedUserID {
                print("Successfully created new user in database.")
                AuthService.instance.logInUserToApp(userID: userID) { (success) in
                    if success {
                        print("User logged in!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.dismiss()
                            isLoading.toggle()
                        }
                    } else {
                        print("Error logging in")
                        self.isError.toggle()
                        isLoading.toggle()
                    }
                }
            } else {
                print("Error creating user in Database")
                self.isError.toggle()
                isLoading.toggle()
            }
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView(name: .constant(""), username: .constant(""), dateOfBirth: .constant(""), provider: .constant(""), providerID: .constant(""))
    }
}

extension CreateAccountView {
    
    var title: some View {
        VStack {
            VStack(spacing: 0) {
                ZStack {
                    Text("Create your profile")
                        .font(.system(size: 18, weight: .semibold))
                    HStack {
                        Button {
                            self.dismiss.callAsFunction()
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
            }
            .background(colorScheme == .dark ? .black : .white)
            Spacer()
        }
    }
    
    var addDetails: some View {
        VStack(spacing: 50) {
            Button {
                sourceType = UIImagePickerController.SourceType.photoLibrary
                showImagePicker.toggle()
            } label: {
                if imageSelected == nil {
                    ZStack {
                        Circle()
                            .frame(width: 200, height: 200)
                            .foregroundColor(Color(.systemGray5))
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                } else {
                    Image(uiImage: imageSelected!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .foregroundColor(Color(.label))
                        .clipShape(Circle())
                }
            }
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .frame(height: 48)
                        .foregroundColor(Color(.systemGray3))
                    HStack {
                        TextField("What's your name?", text: $name)
                            .padding(.horizontal)
                    }
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .frame(height: 48)
                        .foregroundColor(Color(.systemGray3))
                    HStack {
                        TextField("Choose a username", text: $username)
                            .padding(.horizontal)
                    }
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .frame(height: 48)
                        .foregroundColor(Color(.systemGray3))
                    HStack {
                        TextField("What year were you born?", text: $dateOfBirth)
                            .padding(.horizontal)
                    }
                }
                Button {
                    createProfile()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .frame(height: 48)
                            .foregroundColor(.accentColor)
                        if isLoading {
                            ProgressView()
                                .tint(Color.accentColor)
                        } else {
                            Text("Finish")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .buttonStyle(ButtonScaleStyle())
                Text("To stay anonymous, choose a username without any personal information. Your name won't be public.")
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 60)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30)
    }
}
