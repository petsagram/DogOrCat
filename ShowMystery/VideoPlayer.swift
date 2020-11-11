//
//  VideoPlayer.swift
//  ShowMystery
//
//  Created by Vahe Toroyan on 11/8/20.
//

import AVKit
import SwiftUI

class UIVideoPlayer: UIView {

    var videoNotification: NSObjectProtocol!
    var playerLayer = AVPlayerLayer()

    override init(frame: CGRect) {
            super.init(frame: frame)

        let videoURL: NSURL = Bundle.main
                                    .url(forResource: "paw",
                                         withExtension: "mp4")! as NSURL

        let player = AVPlayer(url: videoURL as URL)
            player.isMuted = true
            playerLayer.player = player
            playerLayer.videoGravity = AVLayerVideoGravity(rawValue: AVLayerVideoGravity
                                                                        .resizeAspectFill
                                                                        .rawValue)
            layer.addSublayer(playerLayer)
            player.play()
            self.loopVideo(videoPlayer: player)
    }

    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    override func layoutSubviews() {
            super.layoutSubviews()
            playerLayer.frame = bounds
    }

    func loopVideo(videoPlayer: AVPlayer) {
        self.videoNotification = NotificationCenter
                                    .default
                                    .addObserver(forName: NSNotification
                                                            .Name
                                                            .AVPlayerItemDidPlayToEndTime,
                                                 object: nil,
                                                 queue: nil) { [weak self] _ in
            guard self != nil else { return }
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }

    deinit {
        self.videoNotification = nil
        NotificationCenter.default.removeObserver(self)
    }
}

struct PlayerView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVideoPlayer {
            return UIVideoPlayer()
        }

    func updateUIView(_ uiView: UIVideoPlayer, context: Context) {
        }
}
