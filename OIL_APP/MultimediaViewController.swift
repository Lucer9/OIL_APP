//
//  MultimediaViewController.swift
//  OIL_APP
//
//  Created by periodismo on 4/10/19.
//  Copyright © 2019 JAMO-JMGT-CAO. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MultimediaViewController: AVPlayerViewController {
    var moviePath = "http://ebookfrenzy.com/ios_book/movie/movie.mov"

    override func viewDidLoad() {
        super.viewDidLoad()
        let tipo : String
        
        let videoURL = URL(string: moviePath)
        let player = AVPlayer(url: videoURL!)
        self.player = player
        
        self.player!.play()
    }
        
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

