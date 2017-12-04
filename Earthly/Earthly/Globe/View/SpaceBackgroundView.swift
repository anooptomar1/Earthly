//
//  SpaceBackgroundView.swift
//  Earthly
//
//  Created by Max Rogers on 12/3/17.
//  Copyright © 2017 Max Rogers. All rights reserved.
//

import UIKit
import AVKit

class SpaceBackgroundView: UIView {
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configurePlayer()
    }
    
    // MARK: - Add background video player
    
    func configurePlayer() {
        let urlString = "https://drive.google.com/uc?export=download&id=17pUZ-YLF-Y0xL_Em_I72b5JS50z2YkfE"
        guard let url = URL(string: urlString) else { return }
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.addSublayer(playerLayer)
        player.play()
        loopVideo(videoPlayer: player)
    }
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: kCMTimeZero)
            videoPlayer.play()
        }
    }

}
