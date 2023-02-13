//
//  PhoneAuthView.swift
//  Truthify
//
//  Created by Jacob Lucas on 11/18/22.
//

import SwiftUI

struct PhoneAuthView: View {
    
    @State var phoneNumber: String = ""
    @State var openVerificationView: Bool = false
    
    @State var isLoading: Bool = false
    @State var isError: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            backButton
            enterPhoneNumber
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $isError) {
            Alert(title: Text("Error"), message: Text("An error occured while sending your verification code. Make sure the phone number is correct and try again."), dismissButton: .default(Text("OK")))
        }
        .fullScreenCover(isPresented: $openVerificationView) {
            VerificationCodeView(closeView: $openVerificationView, phoneNumber: $phoneNumber)
        }
    }
    
    func sendCode() {
        self.isLoading = true
        AuthService.instance.sendVerificationCode(phoneNumber: phoneNumber) { (success, error) in
            if success {
                self.isLoading = false
                self.openVerificationView.toggle()
            } else if error {
                self.isError = true
                self.isLoading = false
                print("Error sending verification code.")
            }
        }
    }
}

struct PhoneAuthView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneAuthView()
    }
}

extension PhoneAuthView {
    
    //MARK: back button and logo space
    var backButton: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Enter Phone Number")
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
            Spacer()
        }
    }
    
    //MARK: phone number textfield
    var enterPhoneNumber: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .frame(height: 48)
                    .foregroundColor(Color(.systemGray3))
                ZStack {
                    HStack {
                        Text("+1")
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                    }
                    .padding(.leading)
                    HStack(spacing: 0) {
                        Rectangle()
                            .frame(width: 1, height: 48)
                            .padding(.leading, 50)
                            .foregroundColor(Color(.systemGray3))
                        TextField("000-000-0000", text: $phoneNumber)
                            .keyboardType(.numberPad)
                            .padding()
                    }
                }
            }
            Button {
                sendCode()
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
                        Text("Send Code")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .buttonStyle(ButtonScaleStyle())
            Text("Press 'Send Code' to recieve a verification code and log in. Message and data rates may apply.")
                .multilineTextAlignment(.center)
                .padding(10)
                .font(.system(size: 14))
                .frame(width: UIScreen.main.bounds.width - 60)
                .foregroundColor(.gray)
        }
        .frame(width: UIScreen.main.bounds.width - 30)
    }
    
}
