//
//  TestView.swift
//  Truthify
//
//  Created by Jacob Lucas on 2/6/23.
//

import Foundation
import SwiftUI
import AVKit

struct CustomVideoPlayer: UIViewControllerRepresentable {
    
    @Binding var player: AVPlayer
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CustomVideoPlayer>) -> AVPlayerViewController {
        
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resize
        controller.allowsVideoFrameAnalysis = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<CustomVideoPlayer>) {
        
    }
    
}

//class Host: UIHostingController<FeedView> {
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//}
//}

struct CustomVideoPlayerControls: View {
    
    @Binding var player: AVPlayer
    @Binding var isPlaying: Bool
    @Binding var pannel: Bool
    @Binding var value: Float
    
    var body: some View {
            VStack {
                Spacer()
                HStack {
                    Button {
                        player.seek(to: CMTime(seconds: getSeconds() - 10, preferredTimescale: 1))
                    } label: {
                        Image(systemName: "backward.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button {
                        withAnimation(.spring()) {
                        if isPlaying {
                            player.pause()
                            isPlaying = false
                        } else {
                            player.play()
                            isPlaying = true
                        }
                        }
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button {
                        player.seek(to: CMTime(seconds: getSeconds() + 10, preferredTimescale: 1))
                    } label: {
                        Image(systemName: "forward.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .background(Color.black.opacity(0.4))
            .onTapGesture {
                pannel = false
            }
            .onAppear {
                player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { _ in
                    value = getSliderValue()
                    
                    if value == 1 {
                        isPlaying = false
                    }
                }
        }
    }
    
    func getSliderValue() -> Float {
        return Float(player.currentTime().seconds / (player.currentItem?.duration.seconds)!)
    }
    
    func getSeconds() -> Double {
        return Double(Double(value) * (player.currentItem?.duration.seconds)!)
    }
}

struct CustomProgressBar: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return CustomProgressBar.Coordinator(parent1: self)
    }
    
    @Binding var player: AVPlayer
    @Binding var value: Float
    @Binding var isplaying: Bool
    
    func makeUIView(context: UIViewRepresentableContext<CustomProgressBar>) -> UISlider {
        
        let slider = UISlider()
        slider.minimumTrackTintColor = .lightGray
        slider.maximumTrackTintColor = .white
//        slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
        slider.value = value
        slider.addTarget(context.coordinator, action: #selector(context.coordinator.changed(slider:)), for: .valueChanged)
        return slider
        
    }
    
    func updateUIView(_ uiView: UISlider, context: UIViewRepresentableContext<CustomProgressBar>) {
        uiView.value = value
    }
    
    class Coordinator: NSObject {
        
        var parent: CustomProgressBar
        
        init(parent1: CustomProgressBar) {
            parent = parent1
        }
        @objc func changed(slider: UISlider) {
            if slider.isTracking {
                parent.player.pause()
                let sec = Double(slider.value * Float((parent.player.currentItem?.duration.seconds)!))
                
                parent.player.seek(to: CMTime(seconds: sec, preferredTimescale: 1))
            } else {
                
                let sec = Double(slider.value * Float((parent.player.currentItem?.duration.seconds)!))
                
                parent.player.seek(to: CMTime(seconds: sec, preferredTimescale: 1))
                
                if parent.isplaying {
                    parent.player.play()
                }
            }
        }
    }
    
}

extension AVPlayerViewController {
    open override var prefersStatusBarHidden: Bool {
        return false
    }
}
