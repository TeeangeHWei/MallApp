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
    // 播放器
    var BMplayer = BMPlayer(customControlView: progressView())
    // 播放图标
    var startImg = UIImageView()
    // 播放量
    var playNum = UILabel()
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
        setNavUi()
        BMplayer.playStateDidChange = {(isplaying : Bool)in
            print("正在播放 \(isplaying)")
            if isplaying == false{
                self.startImg.isHidden = false
            }else{
                self.startImg.isHidden = true
            }
        }

    }
    func setNavUi(){
      let coustomNavView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height:headerHeight))
        coustomNavView.backgroundColor = .clear
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: kStatuHeight, width: kScreenW, height: kNavigationBarHeight))
        let navItem = UINavigationItem()
        let backBtn = UIBarButtonItem(image: UIImage(named: "arrow-back"), style: .plain, target: nil, action: #selector(backAction(sender:)))
        backBtn.tintColor = .white
        navItem.setLeftBarButton(backBtn, animated: true)
        navBar.backgroundColor = .clear
        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.pushItem(navItem, animated: true)
        coustomNavView.addSubview(navBar)
        self.view.addSubview(coustomNavView)
        
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
        self.startImg = UIImageView.init()
        self.startImg.isHidden = true
        startImg.image = UIImage(named: "shakeplay")
        BMplayer.addSubview(startImg)
        startImg.snp.makeConstraints { (make) in
            make.size.equalTo(60)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        let playIcon = UIButton.init()
        playIcon.setImage(UIImage(named: "shank_detail_video"), for: .normal)
        BMplayer.addSubview(playIcon)
        playIcon.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview().offset(60)
            make.height.equalTo(30)
            make.width.equalTo(40)
        }
        playNum = UILabel.init()
        playNum.textAlignment = .center
        playNum.textColor = .white
        playNum.text = "111"
        playNum.font = UIFont.systemFont(ofSize: 16)
        BMplayer.addSubview(playNum)
        playNum.snp.makeConstraints { (make) in
            make.top.equalTo(playIcon.snp.bottom).offset(5)
            make.width.equalTo(70)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(5)
        }
        // 文案
        let writeBtn = UIButton.init()
        writeBtn.setImage(UIImage(named: "shank_detail_text"), for: .normal)
        BMplayer.addSubview(writeBtn)
        writeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(playNum.snp.bottom).offset(8)
            make.height.equalTo(43)
            make.width.equalTo(38)
            make.right.equalToSuperview().offset(-8)
        }
        let writeLabel = UILabel.init()
        writeLabel.textAlignment = .center
        writeLabel.textColor = .white
        writeLabel.text = "文案"
        writeLabel.font = UIFont.systemFont(ofSize: 16)
        BMplayer.addSubview(writeLabel)
        writeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(writeBtn.snp.bottom).offset(5)
            make.width.equalTo(45)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-5)
        }
        let shareBtn = UIButton.init()
        shareBtn.setImage(UIImage(named: "shank_detail_share"), for: .normal)
        BMplayer.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.top.equalTo(writeLabel.snp.bottom).offset(8)
            make.height.equalTo(43)
            make.width.equalTo(35)
            make.right.equalToSuperview().offset(-8)
        }
        let shareLabel = UILabel.init()
        shareLabel.textAlignment = .center
        shareLabel.textColor = .white
        shareLabel.text = "分享"
        shareLabel.font = UIFont.systemFont(ofSize: 16)
        BMplayer.addSubview(shareLabel)
        shareLabel.snp.makeConstraints { (make) in
            make.top.equalTo(shareBtn.snp.bottom).offset(5)
            make.width.equalTo(45)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-5)
        }
        
        
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
        
    }
    
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        
      
    }
}
