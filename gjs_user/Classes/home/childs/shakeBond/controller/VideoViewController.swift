//
//  VideoViewController.swift
//  TikTok
//
//  Created by 刘冲 on 2018/12/24.
//  Copyright © 2018 lc. All rights reserved.
//

import UIKit
import AVKit
import BMPlayer
class VideoViewController: ViewController {
    open var videoIndex : Int?
    weak var slider:UISlider!
    weak var videoView : UIView!
    var playerItem : AVPlayerItem?
    var playing = true
    var playerViewController : AVPlayerViewController!
    var startImg : UIButton?
    var singleTouch: UITapGestureRecognizer!
    var BMplayer = BMPlayer(customControlView: progressView())
    let url = URL.init(string: "http://video.haodanku.com/604b62bd6b74e906079f3aaab5019a0e.mp4?attname=1573625176.mp4")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = customNav(titleStr: "", titleColor: kMainTextColor, border: false)
        self.view.addSubview(nav)
        vdieoUI()

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        removeObserver()
    }
    func vdieoUI(){
        view.addSubview(BMplayer)
        BMplayer.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            make.width.equalTo(kScreenW)
            make.height.equalTo(kScreenH)
        }
        BMplayer.videoGravity = AVLayerVideoGravity.resizeAspect
        let asset = BMPlayerResource(url: URL(string: "http://video.haodanku.com/604b62bd6b74e906079f3aaab5019a0e.mp4?attname=1573625176.mp4")!,
                                     name: "")
        BMplayer.setVideo(resource: asset)
        
    }
}
        
extension VideoViewController : BMPlayerDelegate{
    // Call when player orinet changed
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
      player.snp.remakeConstraints { (make) in
        make.top.equalTo(view.snp.top)
        make.left.equalTo(view.snp.left)
        make.right.equalTo(view.snp.right)
        if isFullscreen {
          make.bottom.equalTo(view.snp.bottom)
        } else {
          make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
        }
      }
    }
    
    // Call back when playing state changed, use to detect is playing or not
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
      print("| BMPlayerDelegate | playerIsPlaying | playing - \(playing)")
    }
    
    // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
      print("| BMPlayerDelegate | playerStateDidChange | state - \(state)")
    }
    
    // Call back when play time change
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
      //        print("| BMPlayerDelegate | playTimeDidChange | \(currentTime) of \(totalTime)")
    }
    
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
      //        print("| BMPlayerDelegate | loadedTimeDidChange | \(loadedDuration) of \(totalDuration)")
    }
}
