//
//  ADPhotoLoader.swift
//  gjs_user
//
//  Created by 大杉网络 on 2019/9/4.
//  Copyright © 2019 大杉网络. All rights reserved.
//

import UIKit

//
// 使用
//ADPhotoLoader.share.loadImage(url: url, complete: {[weak self](data: Data?, url: String) in
//    if data != nil {
//        // 处理图片
//    }
//})
//

class ADPhotoLoader {
    var cache = NSCache<AnyObject, AnyObject>()
    
    class var share: ADPhotoLoader {
        struct Static {
            static let instance: ADPhotoLoader = ADPhotoLoader()
        }
        return Static.instance
    }
    
    func loadImage(url: String, complete: @escaping (_ data: Data?, _ url: String) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            /// 先找内存
            var data: Data? = self?.cache.object(forKey: self?.getImageName(filePath: url) as AnyObject) as? Data
//            if let resultData = data {
//                DispatchQueue.main.async {
//                    complete(resultData, url)
//                }
//                print("成功从内存中读取照片")
//                return
//            }
            
            /// 再找本地
            data = self?.readPhotoFromSandbox(fileName: url)
            if data != nil {
                DispatchQueue.main.async {
                    complete(data, url)
                }
//                print("成功从本地中读取照片")
                return
            }
            
            /// 最后从网络下载
            do {
                let imgUrl = URL(string: url)
                data = try Data(contentsOf: imgUrl!)
                DispatchQueue.main.async {
                    complete(data, url)
                }
                if data != nil {
                    // 写入内存
//                    self?.whitePhotoToCache(fileName: url, data: data!)
                    
                    // 写入本地
                    self?.writePhotoToSandbox(fileName: url, data: data!)
                }
                return
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    // 写入照片到内存
//    private func whitePhotoToCache(fileName: String, data: Data) {
//        let key = self.getImageName(filePath: fileName)
//        self.cache.setObject(data as AnyObject, forKey: key as AnyObject)
//        print("成功写入照片到内存")
//    }
    
    // 写入照片到沙盒
    private func writePhotoToSandbox(fileName: String, data: Data) {
        let adPhotoPath:String = NSHomeDirectory() + "/Documents/" + "gjs/"
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: adPhotoPath){// 文件夹不存在，先创建文件夹
            do {
                //withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
                try fileManager.createDirectory(atPath: adPhotoPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        let imagePath = adPhotoPath + getImageName(filePath: fileName)
        
        do {
            try data.write(to: URL(fileURLWithPath: imagePath))
        } catch let error  {
            print(error.localizedDescription)
        }
    }
    
    // 本地沙盒查找Sandbox
    private func readPhotoFromSandbox(fileName: String) -> Data? {
        let fileManager = FileManager.default
        let imageName = getImageName(filePath: fileName)
        let urlsForDocDirectory = fileManager.urls(for: .documentDirectory, in:.userDomainMask)
        let docPath = urlsForDocDirectory[0]
        let file = docPath.appendingPathComponent("gjs/" + imageName)
        
        do {
            let readHandler = try FileHandle(forReadingFrom:file)
            let data = readHandler.readDataToEndOfFile()
            return data
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// 通过图片URL计算得出一个35位的图片名，再去本地找
    private func getImageName(filePath: String) -> String {
        // url过长，不能写入，先转一下Base64
        let utf8EncodeData = filePath.data(using: String.Encoding.utf8, allowLossyConversion: true)
        // 将NSData进行Base64编码
        var base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
        base64String = base64String?.replacingOccurrences(of: "=", with: "")
        base64String = base64String?.replacingOccurrences(of: "+", with: "")
        base64String = base64String?.replacingOccurrences(of: "/", with: "")
        
        // 取前15位+后20位作为图片名
        return base64String!.prefix(15) + base64String!.suffix(20) + ".png"
    }
}
