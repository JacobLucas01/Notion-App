//
//  FinalPreview.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/8/23.
//

import SwiftUI
import AVKit

struct FinalPreview: View {
    
    var disableControls: Bool
    
    @State var player: AVPlayer
    @State var playing: Bool = false
    @State var showControls: Bool = false
    @State var value: Float = 0
    
//    var url: URL
//    var playPreview: Bool
    
    var body: some View {
        ZStack {
            CustomVideoPlayer(player: $player)
            if showControls {
                CustomVideoPlayerControls(player: $player, isPlaying: $playing, pannel: $showControls, value: $value)
            }
            
//            GeometryReader { proxy in
//                let size = proxy.size
//                let player = AVPlayer(url: url)
//                VideoPlayer(player: player)
//                    .aspectRatio(contentMode: .fill)
//                    .edgesIgnoringSafeArea(.vertical)
//                    .frame(width: size.width, height: size.height)
//                    .onAppear {
//                        if playPreview {
//                            player.play()
//                        }
//                    }
//            }
            
        }
        .onAppear {
            player.play()
            playing = true
        }
        .onTapGesture {
            if !disableControls {
                showControls = true
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct FinalPreview_Previews: PreviewProvider {
    static var previews: some View {
        FinalPreview(disableControls: false, player: AVPlayer(url: URL(string: "")!))
    }
}
