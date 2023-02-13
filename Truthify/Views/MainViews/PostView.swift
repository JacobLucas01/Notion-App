//
//  PostView.swift
//  Truthify
//
//  Created by Jacob Lucas on 11/21/22.
//

import SwiftUI
import AVKit

struct PostView: View {
    
    @Binding var isOpen: Bool
    @StateObject var camera = CameraModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                ZStack {
                    CameraPreview()
                        .environmentObject(camera)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.15, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .edgesIgnoringSafeArea(.top)
                    VStack {
                        HStack(alignment: .top) {
                            Button {
                                dismiss.callAsFunction()
                            } label: {
                                ZStack {
                                    Circle()
                                        .frame(width: 30, height: 30)
                                        .opacity(0.0)
                                    Image(systemName: "xmark")
                                        .shadow(color: .black, radius: 10)
                                }
                            }
                            .foregroundColor(.white)
                            .font(.title2)
                            Spacer()
                            ZStack {
                                ZStack {
                                    Circle()
                                        .frame(width: 42, height: 42)
                                        .foregroundColor(.black)
                                        .opacity(0.3)
                                    Circle()
                                        .trim(from: 0.0, to: (camera.recordedDuration / camera.maxDuration))
                                        .stroke(style: StrokeStyle(lineWidth: 3.0, lineCap: .round, lineJoin: .round))
                                        .foregroundColor(.red)
                                        .frame(width: 45, height: 45)
                                        .rotationEffect(Angle(degrees: 270))
                                }
                                Text("\(camera.recordedDuration, specifier: "%.0f")")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                }
                ZStack {
                    Button {
                        if camera.isRecording {
                            camera.stopRecording()
                        } else {
                            camera.startRecording()
                        }
                    } label: {
                        Circle()
                            .frame(width: 55, height: 55)
                            .foregroundColor(camera.isRecording ? .red : .white)
                            .overlay {
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .frame(width: 62, height: 62)
                                    .foregroundColor(camera.isRecording ? .red : .white)
                            }
                    }
                    .padding(.vertical, 10)
                    HStack {
                        Button {
                            self.camera.showPreview.toggle()
                        } label: {
                            if camera.previewURL != nil {
                                Image(systemName: "rectangle.fill.on.rectangle.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: "rectangle.on.rectangle")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                        }
                        .buttonStyle(ButtonScaleStyle())
                        Spacer()
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
                .navigationBarBackButtonHidden(true)
                .padding(.bottom, 25)
                .frame(width: UIScreen.main.bounds.width - 30)
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay(content: {
            if let url = camera.previewURL, camera.showPreview {
                PostPreview(url: url, isOpen: $isOpen)
            }
        })
        .animation(.easeInOut, value: camera.showPreview)
        .onAppear {
            camera.checkCameraPermissions()
        }
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
            if camera.recordedDuration <= camera.maxDuration && camera.isRecording {
                camera.recordedDuration += 0.01
            }
            if camera.recordedDuration >= camera.maxDuration && camera.isRecording {
                camera.stopRecording()
                camera.isRecording = false
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(isOpen: .constant(false))
    }
}

