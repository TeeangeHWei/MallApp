//
//  imgUtils.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/8/12.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import Foundation

// UIImage转base64
func imageBase64 (_ image: UIImage) -> String {
    let imgData = image.jpegData(compressionQuality: 1.0)
    let baseImg = "data:image/png;base64,\(imgData!.base64EncodedString())"
    return baseImg
}

// 图片路径拦截器
func UrlFilter (_ url: String) -> String {
    var imgUrl : String?
    if url.contains("https") {
        imgUrl = url
    } else {
        imgUrl = AlamofireUtil.BASE_IMG_URL + url
    }
    return imgUrl!
}

///图片压缩方法
func resetImgSize(sourceImage : UIImage,maxImageLenght : CGFloat,maxSizeKB : CGFloat) -> Data {
    
    var maxSize = maxSizeKB
    var maxImageSize = maxImageLenght
    
    if (maxSize <= 0.0) {
        maxSize = 1024.0
    }
    
    if (maxImageSize <= 0.0)  {
        maxImageSize = 1024.0
    }
    
    //先调整分辨率
    
    var newSize = CGSize.init(width: sourceImage.size.width, height: sourceImage.size.height)
    let tempHeight = newSize.height / maxImageSize
    let tempWidth = newSize.width / maxImageSize
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSize.init(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
    }else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSize.init(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
    }
    
    UIGraphicsBeginImageContext(newSize)
    sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    var imageData = newImage!.jpegData(compressionQuality: 1.0)
    var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0
    
    //调整大小
    var resizeRate = 0.9
    while (sizeOriginKB > maxSize && resizeRate > 0.1) {
        imageData = newImage!.jpegData(compressionQuality: CGFloat(resizeRate))
        sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
        resizeRate -= 0.1;
    }
    return imageData!
}


//    将某个view 转换成图像
func getImageFromView(view:UIView) -> UIImage {
    UIGraphicsBeginImageContext(view.bounds.size)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}

// 生成二维码
final class QRGenerator {
    // 不带logo
    static func generate(from string: String) -> UIImage? {
        let context = CIContext()
        //        let data = string.data(using: String.Encoding.ascii)
        let data = string.data(using: String.Encoding.utf8)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 7, y: 7)
            if let output = filter.outputImage?.transformed(by: transform), let cgImage = context.createCGImage(output, from: output.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
    // 带logo
    static func setQRCodeToImageView(_ imageView: UIImageView?, _ url: String?) -> UIImage? {
        if imageView == nil || url == nil {
            return nil
        }
        
        // 创建二维码滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 恢复滤镜默认设置
        filter?.setDefaults()
        
        // 设置滤镜输入数据
        let data = url!.data(using: String.Encoding.utf8)
        filter?.setValue(data, forKey: "inputMessage")
        
        // 设置二维码的纠错率
        filter?.setValue("M", forKey: "inputCorrectionLevel")
        
        // 从二维码滤镜里面, 获取结果图片
        var image = filter?.outputImage
        
        // 生成一个高清图片
        let transform = CGAffineTransform.init(scaleX: 20, y: 20)
        image = image?.transformed(by: transform)
        
        // 图片处理
        var resultImage = UIImage(ciImage: image!)
        
        // 设置二维码中心显示的小图标
        let center = UIImage(named: "logo")
        resultImage = getClearImage(sourceImage: resultImage, center: center!)
        
        // 显示图片
        imageView?.image = resultImage
        
        return resultImage
    }
    
    // 使图片放大也可以清晰
    static func getClearImage(sourceImage: UIImage, center: UIImage) -> UIImage {
        
        let size = sourceImage.size
        // 开启图形上下文
        UIGraphicsBeginImageContext(size)
        
        // 绘制大图片
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // 绘制二维码中心小图片
        let width: CGFloat = 120
        let height: CGFloat = 120
        let x: CGFloat = (size.width - width) * 0.5
        let y: CGFloat = (size.height - height) * 0.5
        center.draw(in: CGRect(x: x, y: y, width: width, height: height))
        
        // 取出结果图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return resultImage!
    }
}
