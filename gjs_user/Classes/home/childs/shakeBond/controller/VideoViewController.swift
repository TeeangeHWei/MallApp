//
//  VideoViewController.swift
//  TikTok
//
//  Created by 刘冲 on 2018/12/24.
//  Copyright © 2018 lc. All rights reserved.
//

import UIKit
import AVKit

class VideoViewController: ViewController {
    var playView : shakePlayer!
    open var videoIndex : Int?
    weak var slider:UISlider!
    weak var videoView : UIView!
    var playerItem : AVPlayerItem?
    var playing = true
    var playerViewController : AVPlayerViewController!
    var startImg : UIButton?
    let url = URL.init(string: "http://video.haodanku.com/604b62bd6b74e906079f3aaab5019a0e.mp4?attname=1573625176.mp4")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = customNav(titleStr: "", titleColor: kMainTextColor, border: false)
        self.view.addSubview(nav)
        let url = "http://video.haodanku.com/604b62bd6b74e906079f3aaab5019a0e.mp4?attname=1573625176.mp4"
        
        playView = shakePlayer.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH))
        playView.contrainerVC = self
        playView.urlString(url: url as NSString)
        self.view.addSubview(playView)
//        videoUI()
        addObserver()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pauseandstart(sender:))))

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        removeObserver()
    }
    
    func videoUI(){
        playerItem = AVPlayerItem(url: url!)
        playerViewController = AVPlayerViewController()
        playerViewController.player = AVPlayer(playerItem: playerItem)
        playerViewController.showsPlaybackControls = false
       //添加view播放的模式
        playerViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: UIScreen.main.bounds.height)
        self.addChild(playerViewController)
        self.view.addSubview(playerViewController.view)
        // 播放按钮
        startImg = UIButton.init()
        startImg?.setImage(UIImage(named: "shakeplay"), for:.normal)
        startImg?.isSelected = false
        startImg?.addTarget(self, action: #selector(start(sender:)), for: .touchUpInside)
        self.view.addSubview(startImg!)
        startImg?.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(60)
        }
        
    }
    @objc func start(sender: UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected == false {
           
           playerViewController?.player?.pause()
            startImg?.isHidden = true
        }else{
            startImg?.isHidden = false
            playerViewController?.player?.play()
        }
    }
    @objc func pauseandstart(sender :UIView){
//        sender.tag = 1
//        if sender.tag == 1 {
//
//           playerViewController?.player?.pause()
//        }else{
//            playerViewController?.player?.play()
//        }
        
    }
    func addObserver() {
        // 监听loadedTimeRanges属性来监听缓冲进度更新
        playerItem?.addObserver(self,
                                forKeyPath: "loadedTimeRanges",
                                options: .new,
                                context: nil)
        // 监听status属性进行播放
        playerItem?.addObserver(self,
                                forKeyPath: "status",
                                options: .new,
                                context: nil)
    }

    func removeObserver() {
        playerItem?.removeObserver(self, forKeyPath: "status")
        playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        print("移除了")
     }

    deinit {
        removeObserver()
     }
    override func observeValue(forKeyPath keyPath: String?,
                                 of object: Any?,
                                 change: [NSKeyValueChangeKey : Any]?,
                                 context: UnsafeMutableRawPointer?) {
          guard let object = object as? AVPlayerItem  else { return }
          guard let keyPath = keyPath else { return }
          if keyPath == "status" {
              if object.status == .readyToPlay { //当资源准备好播放，那么开始播放视频
                  startImg?.isHidden = true
                  playerViewController?.player?.play()
                  print("正在播放...，视频总长度:\(formatPlayTime(seconds: CMTimeGetSeconds(object.duration)))")
              } else if object.status == .failed || object.status == .unknown {
                  print("播放出错")
              }
          } else if keyPath == "loadedTimeRanges" {
              let loadedTime = availableDurationWithplayerItem()
              print("当前加载进度\(loadedTime)")
          }
    }

    // 将秒转成时间字符串的方法，因为我们将得到秒。
    func formatPlayTime(seconds: Float64) -> String {
        let min = Int(seconds / 60)
        let sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", min, sec)
    }

    // 计算当前的缓冲进度
    func availableDurationWithplayerItem() -> TimeInterval {
        guard let loadedTimeRanges = playerViewController.player?.currentItem?.loadedTimeRanges,
            let first = loadedTimeRanges.first else {
                 fatalError()
         }
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start) // 本次缓冲起始时间
        let durationSecound = CMTimeGetSeconds(timeRange.duration)// 缓冲时间
        let result = startSeconds + durationSecound// 缓冲总长度
        return result
    }


}
