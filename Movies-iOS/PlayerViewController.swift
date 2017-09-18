//
//  PlayerViewController.swift
//  Movies-iOS
//
//  Created by Tim Roesner on 9/16/17.
//  Copyright © 2017 Tim Roesner. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class PlayerViewController: AVPlayerViewController, AVPlayerViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            // report for an error
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playVideo()
    }
    
    func playVideo() {
        player = AVPlayer(url: URL(string: currentMovie.link)!)
        player?.play()
    }
    
}
