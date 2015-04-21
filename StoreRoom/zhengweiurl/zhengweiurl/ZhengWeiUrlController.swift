//
//  ZhengWeiUrlController.swift
//  zhengweiurl
//
//  Created by wlpiaoyi on 15/2/11.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

import UIKit
let ZWBUTTON_TITLE_DEFUALT:String! = "没跳转请按我!";
class ZhengWeiUrlController: UIViewController {
    var buttonUrl:UIButton! = nil;
    var timerButton:NSTimer! = nil;
    override class func initialize() {
        super.initialize();
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var _buttonUrl = UIButton.buttonWithType(UIButtonType.Custom) as UIButton;
        _buttonUrl.addTarget(self, action:sel_getUid("onclickUrl:") , forControlEvents: UIControlEvents.TouchUpInside);
        _buttonUrl.setTitle("test", forState: UIControlState.Normal);
        _buttonUrl.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal);
        _buttonUrl.frame = CGRectMake((CGRectGetWidth(UIScreen.mainScreen().bounds)-150)/2, CGRectGetHeight(UIScreen.mainScreen().bounds)-80, 150, 40);
        
        _buttonUrl.layer.shadowRadius = 5;
        _buttonUrl.layer.shadowOpacity = 1;
        _buttonUrl.layer.shadowColor = UIColor.whiteColor().CGColor;
        _buttonUrl.layer.shadowOffset = CGSizeMake(0, 0);
        _buttonUrl.clipsToBounds = false;

        self.buttonUrl = _buttonUrl;
        self.buttonUrl.tag = 5;
        self.navigationController?.setNavigationBarHidden(true, animated: true);
        timerButton = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: sel_getUid("timerButtonCheck"), userInfo: nil, repeats: true);
        var imagebg:UIImage = UIImage(named: "1242-2208.png")!;
        var imageviewbg:UIImageView = UIImageView(image: imagebg);
        imageviewbg.contentMode = UIViewContentMode.ScaleAspectFill;
        imageviewbg.frame = UIScreen.mainScreen().bounds;
        self.view.addSubview(imageviewbg);
        self.view.addSubview(self.buttonUrl);
    }
    func timerButtonCheck(){
        if (self.buttonUrl == nil){
            return;
        }
        if(self.buttonUrl.tag <= 0){
            timerButton.invalidate();
            self.buttonUrl.tag = 0;
            buttonUrl.userInteractionEnabled = true;
            buttonUrl.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal);
        }else{
            buttonUrl.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal);
            buttonUrl.userInteractionEnabled = false;
        }
        var title:String! = NSString(format:"%@[%i]", ZWBUTTON_TITLE_DEFUALT,self.buttonUrl.tag);
        buttonUrl.setTitle(title, forState: UIControlState.Normal);
        buttonUrl.tag = buttonUrl.tag-1;
    }
    func onclickUrl(sender:AnyObject)->Void{
        NSLog("funck %@", "---");
        var url:NSURL = NSURL(string: "http://www.baidu.com")!;
        UIApplication.sharedApplication().openURL(url);
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.timerButton.fire();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
