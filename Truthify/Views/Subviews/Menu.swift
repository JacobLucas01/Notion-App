//
//  Menu.swift
//  Truthify
//
//  Created by Jacob Lucas on 11/19/22.
//

import SwiftUI

struct Menu: View {
    
    @Binding var numOfNotifications: Int
    @Binding var viewSelection: String
    @Binding var newPost: Bool
    
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var notifications = NotificationService()
    
    var body: some View {
        HStack {
            if viewSelection == "house" {
                Image(systemName: "house.fill")
                    .frame(maxWidth: .infinity)
            } else {
                Image(systemName: "house")
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        viewSelection = "house"
                    }
            }
            Image(systemName: "plus.square")
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    newPost.toggle()
                }
            ZStack(alignment: .topTrailing) {
                if viewSelection == "bell" {
                    Image(systemName: "bell.fill")
                } else {
                    Image(systemName: "bell")
                        .onTapGesture {
                            viewSelection = "bell"
                        }
                }
                if numOfNotifications > 0 {
                    Circle()
                        .frame(width: 5, height: 5)
                        .foregroundColor(.red)
                }
            }
            .frame(maxWidth: .infinity)
            if viewSelection == "person.crop.circle" {
                Image(systemName: "person.crop.circle.fill")
                    .frame(maxWidth: .infinity)
            } else {
                Image(systemName: "person.crop.circle")
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        viewSelection = "person.crop.circle"
                    }
            }
        }
        .font(.title2)
        .foregroundColor(viewSelection == "house" ? .white : Color(.label))
        .padding(.vertical, 12)
        .padding(.bottom, 26)
        .background {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width)
                .foregroundColor(viewSelection == "house" ? .black : (colorScheme == .light ? .white : .black))
        }
        .edgesIgnoringSafeArea(.bottom)
        .buttonStyle(ButtonScaleStyle())
    }
}

struct Menu_Previews: PreviewProvider {
    @State static var page: String = "house"
    static var previews: some View {
        Menu(numOfNotifications: .constant(0), viewSelection: $page, newPost: .constant(false))
    }
}
