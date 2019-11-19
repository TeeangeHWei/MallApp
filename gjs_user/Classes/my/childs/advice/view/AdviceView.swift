//
//  adviceView.swift
//  gjs_user
//
//  Created by xiaofeixia on 2019/8/22.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

class AdviceView: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    private let imgWidth:CGFloat = (kScreenW - 40)/3
    private var imgBox:UIView!
    private var content:IDTextView!
    private var imgs:[Int:String] = [Int:String]()
    private var imgList:[Int:UIView] = [Int:UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navView = customNav(titleStr: "意见反馈", titleColor: kMainTextColor)
        self.view.addSubview(navView)
        let mainView = UIView(frame: CGRect(x: 0, y: headerHeight, width: kScreenW, height: kScreenH))
        mainView.backgroundColor = .white
        content = IDTextView(frame: CGRect(x: 10, y: 10, width: kScreenW-20, height: 180))
        content.backgroundColor = kBGGrayColor
        content.layer.cornerRadius = 10
        content.font = FontSize(16)
        content.id_placehoder = "请输入您的建议(100字以内)"
        content.id_placehoderColor = kGrayTextColor
        content.id_maxLength = 100
        content.layer.borderWidth = 0
        
        imgBox = UIView(frame: CGRect(x: 10, y: 210, width: imgWidth, height: imgWidth))
        imgBox.layer.cornerRadius = 10
        imgBox.backgroundColor = kBGGrayColor
        let addImg = UIImageView(image: UIImage(named: "add"))
        addImg.frame = CGRect(x: imgWidth/2/2, y: imgWidth/2/2, width: imgWidth/2, height: imgWidth/2)
        imgBox.addSubview(addImg)
        imgBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePicker)))
        
        let btn = UIButton(frame: CGRect(x: 10, y: 360, width: kScreenW - 20, height: 50))
        btn.setTitle("提交建议", for: .normal)
        btn.gradientColor(CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5), kCGGradientColors)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        mainView.addSubview(content)
        mainView.addSubview(imgBox)
        mainView.addSubview(btn)
        self.view.addSubview(mainView)
    }
    
    // 创建UIImagePickerController对象,设置数据源和代理,跳转到图片选择控制器
    func imageFormPhotosAlbum(){
        let picker = UIImagePickerController()
        //设置代理
        picker.delegate = self
        //设置数据源(从相册或者相机)
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    // 监听选择完照片后返回照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 根据UIImagePickerControllerOriginalImage从info里边取值
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let data = resetImgSize(sourceImage: image, maxImageLenght: 500, maxSizeKB: 100)
        let temp = UIImage(data: data)
        imgs[imgs.count + 1] = imageBase64(temp!)
        if(imgs.count == 3){
            imgs.remove(at: imgs.index(forKey: 3)!)
            imgs[0] = imageBase64(temp!)
            addImg(image: image,count:0)
        }else if(imgs.count < 3){
            addImg(image: image,count:imgs.count)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 添加图片（重新渲染）
    func addImg(image:UIImage,count:Int){
        let box = UIView()
        box.tag = count+10
        let a = Float(count) * Float(imgWidth)
        let b = Float(count) * 10
        let x = a + b + 10
        box.frame = CGRect(x: CGFloat(x), y: (kScreenW*0.715), width: imgWidth, height: imgWidth)
        
        let img = UIImageView(image: image)
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 5
        img.frame = box.bounds
        
        let close = UIImageView(frame: CGRect(x: imgWidth - 14, y: -10, width: 24, height: 24))
        close.image = UIImage(named: "close-danger")
        close.tag = count
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteImg(sender:))))
        
        box.addSubview(img)
        box.addSubview(close)
        //更新渲染图片
        imgList[count] = box
        showImg()
    }
    
    func updateImg(box:UIView,count:Int) -> UIView{
        box.tag = count+10
        let a = Float(count) * Float(imgWidth)
        let b = Float(count) * 10
        let x = a + b + 10
        box.frame = CGRect(x: CGFloat(x), y: 210, width: imgWidth, height: imgWidth)
        
        let close = UIImageView(frame: CGRect(x: imgWidth - 14, y: -10, width: 24, height: 24))
        close.image = UIImage(named: "close-danger")
        close.tag = count
        close.isUserInteractionEnabled = true
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteImg(sender:))))
 
        box.addSubview(close)
        return box
    }
    
    //渲染图片
    func showImg(){
        for i in 0..<3{
            if(imgList[i] != nil){
                self.view.addSubview(imgList[i]!)
            }
        }
    }
    
    //删除图片（重新渲染）
    @objc func deleteImg(sender:UITapGestureRecognizer){
        //移除视图
        UIApplication.shared.keyWindow!.viewWithTag(sender.view!.tag+10)?.removeFromSuperview()
        //移除base64
        imgList.remove(at: imgList.index(forKey: sender.view!.tag)!)
        imgs.remove(at: imgs.index(forKey: sender.view!.tag)!)
        if(sender.view!.tag == 1){
            if(imgList[0] != nil){
                //移除close
                UIApplication.shared.keyWindow!.viewWithTag(0)?.removeFromSuperview()
                imgList[1] = updateImg(box:imgList[0]!,count:1)
                imgs[1] = imgs[0]
                imgList.remove(at: imgList.index(forKey: 0)!)
                imgs.remove(at: imgs.index(forKey: 0)!)
            }else if(imgList[2] != nil){
                //移除close
                UIApplication.shared.keyWindow!.viewWithTag(2)?.removeFromSuperview()
                imgList[1] = updateImg(box:imgList[2]!,count:1)
                imgs[1] = imgs[2]
                imgList.remove(at: imgList.index(forKey: 2)!)
                imgs.remove(at: imgs.index(forKey: 2)!)
            }
        }else if(sender.view!.tag == 2){
            if(imgList[0] != nil){
                //移除close
                UIApplication.shared.keyWindow!.viewWithTag(0)?.removeFromSuperview()
                imgList[2] = updateImg(box:imgList[0]!,count:2)
                imgs[2] = imgs[0]
                imgList.remove(at: imgList.index(forKey: 0)!)
                imgs.remove(at: imgs.index(forKey: 0)!)
            }
        }
        showImg()
    }
    
    @objc func imagePicker(){
        imageFormPhotosAlbum()
    }
    
    @objc func submit(){
        if(content.text! == ""){
            IDToast.id_show(msg: "请填写建议内容", success:.fail)
            return
        }
        var imgStr:[String] = [String]()
        for i in 0..<3{
            if(imgs[i] != nil){
                imgStr.append(imgs[i]!)
            }
        }
        AlamofireUtil.upload(url: "/user/advice/feedback",
        param: [
            "content":content.text!,
            "imgs" : imgStr.description
        ],
        success: { (data) in
            IDToast.id_show(msg: "提交成功",success:.success)
            self.navigationController?.popViewController(animated: true)
        },
        error: {},
        failure: {})
    }
}
