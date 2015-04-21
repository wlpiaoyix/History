//
//  AsynImageView.swift
//  zhengweiurl
//
//  Created by wlpiaoyi on 15/2/17.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

import UIKit


typealias FunctionAsynImageViewDownloadSuccess = ()->Void;
var LetImageDataCacatchPath:String = "";
/**
 异步图片
 */
class AsynImageView: UIImageView {

    private var function:FunctionAsynImageViewDownloadSuccess?;
    private var imageUrl:String?;
    private var httpDownload:HttpUtilsDownloadImpl?;
    var hasImageCache:Bool;
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setImageUrl(_imageurl_:String){
        imageUrl = _imageurl_;
        
        if(httpDownload != nil){
            httpDownload?.cancel();
        }
        if(imageUrl == nil || imageUrl?.isEmpty==true){
            self.image = nil;
            return;
        }
        
        var path:String = AsynImageView.checkImageUrlReturnPath(imageUrl);
        
        if(NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: nil)){
            var imageData:NSData? = NSData(contentsOfFile: path)!;
            if(imageData != nil && imageData?.length>0){
                var image:UIImage = UIImage(data: imageData!)!;
                self.image = image;
            }else{
                self.image = nil;
            }
        }else{
            self.startDownloadImageData(imageUrl);
        }
    }
    
    private func setFunctionAsynImageViewDownloadSuccess(_function_:FunctionAsynImageViewDownloadSuccess){
        function = _function_;
    }
    
    /**
     开始下载图片数据
     */
    private func startDownloadImageData(_imageUrl_:String!) {
        httpDownload = HttpUtilsDownloadImpl(isBackground: self.hasImageCache);
        httpDownload?.setUserInfo(["imageUrl":_imageUrl_]);
        httpDownload?.setUrl(_imageUrl_);
        httpDownload?.setDataChange({ (persent:CGFloat) -> Void in
            println("image data download:%f",persent);
        })
        httpDownload?.setStatusChageFunction({ (status:EnumHttpUtilsStatus,  dataDic:NSDictionary?, userInfo:NSDictionary?) -> Void in
            if(EnumHttpUtilsStatus.Success == status){
                var imagePath:String? = dataDic?.valueForKey("path") as? String;
                var imageData:NSData? = dataDic?.valueForKey("data") as? NSData;
                if(imagePath != nil && imagePath?.isEmpty == false){
                    var path:String = AsynImageView.checkImageUrlReturnPath(_imageUrl_!);
                    if(NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: nil)){
                        var erro:NSError?;
                        NSFileManager.defaultManager().removeItemAtPath(path, error: nil);
                    }
                    NSFileManager.defaultManager().moveItemAtPath(imagePath!, toPath: path, error: nil);
                    imageData = NSData(contentsOfFile: path)!;
                }
                if(imageData != nil && imageData?.length>0){
                    var image:UIImage = UIImage(data: imageData!)!;
                    self.image = image;
                }else{
                    self.image = nil;
                }
                if(self.function != nil){
                    self.function!();
                }
            }
        });
        httpDownload?.resume();
    }
    /**
     通过imageUrl取得对应的路径
     */
    private class func checkImageUrlReturnPath(_imageUrl_:String!)->String{
        
        var array:NSArray = NSString(format: "%s", _imageUrl_).componentsSeparatedByString("/");
        var lastArg:String = array.lastObject as String;
        
        var path:String = LetImageDataCacatchPath.stringByAppendingString("/");
        path = path.stringByAppendingString(lastArg);
        
        return path;
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
