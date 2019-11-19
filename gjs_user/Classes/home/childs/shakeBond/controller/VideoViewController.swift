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
import NVActivityIndicatorView

class VideoViewController: ViewController {
    open var videoIndex : Int?
    var playing = true
    var startImg : UIButton?
    var BMplayer = BMPlayer(customControlView: progressView())
    //播放器状态
    var state : BMPlayerState?
    let url = URL.init(string: "http://video.haodanku.com/604b62bd6b74e906079f3aaab5019a0e.mp4?attname=1573625176.mp4")
    var player: BMPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        BMplayer.removeGestureRecognizer(BMplayer.panGesture)
        let nav = customNav(titleStr: "", titleColor: kMainTextColor, border: false)
        self.view.addSubview(nav)
        // 是否打印日志，默认false
        BMPlayerConf.allowLog = true
        // 是否自动播放，默认true
        BMPlayerConf.shouldAutoPlay = true
        BMPlayerConf.loaderType  = NVActivityIndicatorType.ballBeat
        vdieoUI()

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        BMplayer.pause(allowAutoPlay: true)
    }
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      // If use the slide to back, remember to call this method
      // 使用手势返回的时候，调用下面方法
     if state == BMPlayerState.playedToTheEnd{
         BMplayer.play()
     }
      print("调用了viewWillAppear")
      BMplayer.play()
    }
    
    func vdieoUI(){
        view.addSubview(BMplayer)
        BMplayer.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
//        BMplayer.videoGravity = AVLayerVideoGravity.resize
        
        let asset = BMPlayerResource(url: URL(string: "http://video.haodanku.com/604b62bd6b74e906079f3aaab5019a0e.mp4?attname=1573625176.mp4")!,
                                     name: "")
        BMplayer.setVideo(resource: asset)
        NotificationCenter.default.addObserver(self,
                                                 selector: #selector(applicationDidEnterBackground),
                                                 name: UIApplication.didEnterBackgroundNotification,
                                                 object: nil)
          
        NotificationCenter.default.addObserver(self,
                                                 selector: #selector(applicationWillEnterForeground),
                                                 name: UIApplication.willEnterForegroundNotification,
                                                 object: nil)
        }
        
        @objc func applicationWillEnterForeground() {
          
        }
        
        @objc func applicationDidEnterBackground() {
          BMplayer.pause(allowAutoPlay: false)
        }
        
    }
    
        
extension VideoViewController : BMPlayerDelegate{
    // Call when player orinet changed
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
      BMplayer.snp.remakeConstraints { (make) in
        make.top.equalTo(view.snp.top)
        make.left.equalTo(view.snp.left)
        make.right.equalTo(view.snp.right)
        if isFullscreen {
          make.bottom.equalTo(view.snp.bottom)
        } else {
          make.height.equalTo(view.snp.width)
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
