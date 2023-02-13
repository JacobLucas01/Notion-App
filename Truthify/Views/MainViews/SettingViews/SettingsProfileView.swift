//
//  SettingsProfileView.swift
//  Truthify
//
//  Created by Jacob Lucas on 2/11/23.
//

import SwiftUI

struct SettingsProfileView: View {
    
    @Binding var profileImage: UIImage?
    
    @Environment(\.dismiss) var dismiss
    
    @State var name: String
    @State var username: String
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Profile")
                    .font(.system(size: 18, weight: .semibold))
                HStack {
                    Button {
                        self.dismiss.callAsFunction()
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                            Text("Settings")
                        }
                        .foregroundColor(Color(.label))
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
            }
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width - 30)
            Divider()
            Form {
                Section {
                    NavigationLink {
                            EditProfileImageView(profileImage: $profileImage)
                    } label: {
                        HStack(spacing: 20) {
                            Spacer()
                            if let image = profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .padding(.vertical, 4)
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .padding(.vertical, 8)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
              //  .listRowBackground(Color(UIColor.systemGroupedBackground))
                Section {
                    NavigationLink {
                            EditNameView(name: name)
                    } label: {
                        HStack {
                            Text("name")
                            .foregroundColor(Color(.systemGray3))
                            Spacer()
                            Text(name)
                                .padding(.trailing)
                        }
                    }
                    NavigationLink {
                            EditUsernameView(username: username)
                    } label: {
                        HStack {
                            Text("username")
                                .foregroundColor(Color(.systemGray3))
                            Spacer()
                            Text(username)
                                .padding(.trailing)
                        }
                    }
                }
                .font(.system(size: 18))
                .foregroundColor(Color(.label))
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SettingsProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsProfileView(profileImage: .constant(UIImage(systemName: "person.crop.circle.fill")), name: "", username: "")
    }
}
