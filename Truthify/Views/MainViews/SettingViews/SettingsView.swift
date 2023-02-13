//
//  SettingsView.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/25/23.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var profileImage: UIImage?
    
    @Environment(\.dismiss) var dismiss

    @AppStorage("user_id") var currentUserID: String?
    @AppStorage("name") var currentUserName: String?
    @AppStorage("username") var currentUserUsername: String?
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Settings")
                    .font(.system(size: 18, weight: .semibold))
                HStack {
                    Button {
                        self.dismiss.callAsFunction()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
            }
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width - 30)
            Divider()
            Form {
                Section(header: Text("ACCOUNT")) {
                    NavigationLink {
                        if let name = currentUserName, let username = currentUserUsername {
                            SettingsProfileView(profileImage: $profileImage, name: name, username: username)
                        }
                    } label: {
                        HStack(spacing: 20) {
                            if let image = profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .padding(.vertical, 4)
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .padding(.vertical, 4)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                if let name = currentUserName {
                                    Text(name)
                                        .font(.system(size: 20, weight: .medium))
                                }
                                if let username = currentUserUsername {
                                    Text("@" + username)
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(.systemGray2))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                Section(header: Text("PRIVACY")) {
                    NavigationLink(destination: Text("view")) {
                        Label {
                            Text("Phone")
                        } icon: {
                            Image(systemName: "phone")
                                .foregroundColor(Color(.label))
                        }
                    }
                    NavigationLink(destination: Text("view")) {
                        Label {
                            Text("Your Data")
                        } icon: {
                            Image(systemName: "archivebox")
                                .foregroundColor(Color(.label))
                        }
                    }
                }
                Section(header: Text("SYSTEM")) {
                    NavigationLink(destination: Text("view")) {
                        Label {
                            Text("Display")
                        } icon: {
                            Image(systemName: "sun.max")
                                .foregroundColor(Color(.label))
                        }
                    }
                }
                Section(header: Text("ABOUT")) {
                    NavigationLink(destination: Text("view")) {
                        Label {
                            Text("Contact")
                        } icon: {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(Color(.label))
                        }
                    }
                    NavigationLink(destination: Text("view")) {
                        Label {
                            Text("Privacy Policy")
                        } icon: {
                            Image(systemName: "lock")
                                .foregroundColor(Color(.label))
                        }
                    }
                    NavigationLink(destination: Text("view")) {
                        Label {
                            Text("Terms & Conditions")
                        } icon: {
                            Image(systemName: "doc.plaintext")
                                .foregroundColor(Color(.label))
                        }
                    }
                }
                Section {
                    Button {
                        AuthService.instance.logOutUser { success in
                            if success {
                                print("User has been successfully logged out.")
                            }
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Spacer()
                            Image(systemName: "hand.wave.fill")
                            Text("Sign Out")
                            Spacer()
                        }
                        .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(profileImage: .constant(UIImage(systemName: "person.crop.circle.fill")))
        }
    }
}
