//
//  PostPreview.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/22/23.
//

import SwiftUI
import AVKit

struct PostPreview: View {
    
    let url: URL
    @Binding var isOpen: Bool
    @StateObject var camera = CameraModel()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                FinalPreview(disableControls: false, player: AVPlayer(url: url))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.18, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .edgesIgnoringSafeArea(.top)
                ZStack {
                        Circle()
                            .frame(width: 55, height: 55)
                            .foregroundColor(camera.isRecording ? .red : .white)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .frame(width: 62, height: 62)
                                    .foregroundColor(camera.isRecording ? .red : .white)
                            }
                    .opacity(0.0)
                    HStack {
                        Button {
                            camera.showPreview.toggle()
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .opacity(0.0)
                                Image(systemName: "chevron.left")
                            }
                        }
                        .font(.title2)
                        .foregroundColor(.white)
                        .buttonStyle(ButtonScaleStyle())
                        Spacer()
                        NavigationLink {
                            UploadPostView(url: url, landmarkLocation: "", videoURL: $camera.previewURL, isOpen: $isOpen)
                        } label: {
                            HStack {
                                Text("Add Details")
                                Image(systemName: "chevron.right")
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(12)
                            .background {
                                Color.accentColor
                            }
                            .cornerRadius(.infinity)
                        }
                        .buttonStyle(ButtonScaleStyle())
                    }
                    .padding(.horizontal)
                    .font(.system(size: 15))
                }
                .navigationBarBackButtonHidden(true)
                .padding(.bottom, 25)
                .frame(width: UIScreen.main.bounds.width - 30)
            }
        }
    }
}

struct PostPreview_Previews: PreviewProvider {
    static var previews: some View {
        PostPreview(url: URL(string: "")!, isOpen: .constant(false))
    }
}
