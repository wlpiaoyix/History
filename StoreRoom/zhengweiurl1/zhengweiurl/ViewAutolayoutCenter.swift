//
//  ViewAutolayoutCenter.swift
//  zhengweiurl
//
//  Created by wlpiaoyi on 15/2/11.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

import UIKit
/**
 最大失效值
 */
let DisableConstrainsValueMAX:CGFloat = CGFloat.max/2;
/**
 最小失效值
 */
let DisableConstrainsValueMIN:CGFloat = -DisableConstrainsValueMAX;
/**
 自动布局设置
 */
class ViewAutolayoutCenter: NSObject {
    
//    class func aatest(function:functionTypetest) {
//        function(["a":"v","b":"v"]);
//    }
    
    /**
    删除相关的约束
    */
    class func removeConstraints(targetView:UIView){
//        self.aatest { (b) -> Void in
//            var v1 = b?.objectForKey("a");
//            var v2 = b?.objectForKey("b");
//        }
        targetView.setTranslatesAutoresizingMaskIntoConstraints(false);
        var constraints:NSArray? = targetView.constraints();
        if(constraints?.count > 0){
            for constraint in (constraints)! {
                if(constraint.isKindOfClass(NSLayoutConstraint.classForCoder())){
                    targetView.removeConstraint((constraint) as NSLayoutConstraint);
                    continue;
                }
                if(constraint.isKindOfClass(NSArray.classForCoder())){
                    targetView.removeConstraints((constraint) as NSArray);
                    continue;
                }
                
            }
        }
    }
    /**
    新增关系约束
    */
    class func persistConstraintRelation(targetView:UIView,margins:UIEdgeInsets,toItems:NSDictionary?){
        targetView.setTranslatesAutoresizingMaskIntoConstraints(false);
        if(self.isValueEnable(margins.top)){
            var itemView:UIView? = toItems?.objectForKey("top") as? UIView;
            var itemAtt:NSLayoutAttribute = NSLayoutAttribute.Bottom;
            var targetAtt:NSLayoutAttribute = NSLayoutAttribute.Top;
            var relation:NSLayoutRelation = NSLayoutRelation.Equal;
            var constant:CGFloat = margins.top;
            if(itemView == nil){
                itemView = targetView.superview;
                itemAtt = NSLayoutAttribute.Top;
            }
            var layoutConstraint:NSLayoutConstraint = NSLayoutConstraint(item: targetView, attribute: targetAtt, relatedBy: relation, toItem: itemView, attribute: itemAtt, multiplier: 1, constant: constant);
            targetView.superview?.addConstraint(layoutConstraint);
        }
        if(self.isValueEnable(margins.bottom)){
            var itemView:UIView? = toItems?.objectForKey("bottom") as? UIView;
            var itemAtt:NSLayoutAttribute = NSLayoutAttribute.Top;
            var targetAtt:NSLayoutAttribute = NSLayoutAttribute.Bottom;
            var relation:NSLayoutRelation = NSLayoutRelation.Equal;
            var constant:CGFloat = margins.bottom;
            if(itemView == nil){
                itemView = targetView.superview;
                itemAtt = NSLayoutAttribute.Bottom;
            }
            var layoutConstraint:NSLayoutConstraint = NSLayoutConstraint(item: targetView, attribute: targetAtt, relatedBy: relation, toItem: itemView, attribute: itemAtt, multiplier: 1, constant: -constant);
            targetView.superview?.addConstraint(layoutConstraint);
        }
        if(self.isValueEnable(margins.left)){
            var itemView:UIView? = toItems?.objectForKey("left") as? UIView;
            var itemAtt:NSLayoutAttribute = NSLayoutAttribute.Right;
            var targetAtt:NSLayoutAttribute = NSLayoutAttribute.Left;
            var relation:NSLayoutRelation = NSLayoutRelation.Equal;
            var constant:CGFloat = margins.left;
            if(itemView == nil){
                itemView = targetView.superview;
                itemAtt = NSLayoutAttribute.Left;
            }
            var layoutConstraint:NSLayoutConstraint = NSLayoutConstraint(item: targetView, attribute: targetAtt, relatedBy: relation, toItem: itemView, attribute: itemAtt, multiplier: 1, constant: constant);
            targetView.superview?.addConstraint(layoutConstraint);
        }
        if(self.isValueEnable(margins.right)){
            var itemView:UIView? = toItems?.objectForKey("right") as? UIView;
            var itemAtt:NSLayoutAttribute = NSLayoutAttribute.Left;
            var targetAtt:NSLayoutAttribute = NSLayoutAttribute.Right;
            var relation:NSLayoutRelation = NSLayoutRelation.Equal;
            var constant:CGFloat = margins.right;
            if(itemView == nil){
                itemView = targetView.superview;
                itemAtt = NSLayoutAttribute.Right;
            }
            var layoutConstraint:NSLayoutConstraint = NSLayoutConstraint(item: targetView, attribute: targetAtt, relatedBy: relation, toItem: itemView, attribute: itemAtt, multiplier: 1, constant: -constant);
            targetView.superview?.addConstraint(layoutConstraint);
        }
    }
    /**
    新增大小约束
    */
    class func persistConstraintSize(targetView:UIView,width:CGFloat,height:CGFloat){
        var layoutConstraints:NSMutableArray! = NSMutableArray();
        targetView.setTranslatesAutoresizingMaskIntoConstraints(false);
        if(self.isValueEnable(width)){
            var layoutConstraint:NSLayoutConstraint = NSLayoutConstraint(item: targetView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier:1, constant: width);
            layoutConstraints.addObject(layoutConstraint);
        }
        
        if(self.isValueEnable(height)){
            var layoutConstraint:NSLayoutConstraint = NSLayoutConstraint(item: targetView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier:1, constant: height);
            layoutConstraints.addObject(layoutConstraint);
            
        }
        targetView.superview?.addConstraints(layoutConstraints);
    }
    /*
    新增布局约束
    */
    class func persistConstraintCenter(targetView:UIView!, offsetx:CGFloat, offsety:CGFloat){
        var layoutConstraints:NSMutableArray! = NSMutableArray();
        targetView.setTranslatesAutoresizingMaskIntoConstraints(false);
        if(self.isValueEnable(offsetx)){
            var layoutConstraint:NSLayoutConstraint = NSLayoutConstraint(item: targetView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: targetView.superview, attribute: NSLayoutAttribute.CenterX, multiplier:1, constant: offsetx);
            layoutConstraints.addObject(layoutConstraint);
        }
        if(self.isValueEnable(offsety)){
            var layoutConstraint:NSLayoutConstraint = NSLayoutConstraint(item: targetView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: targetView.superview, attribute: NSLayoutAttribute.CenterY, multiplier:1, constant: offsety);
            layoutConstraints.addObject(layoutConstraint);
        }
        targetView.superview?.addConstraints(layoutConstraints);
    }
    /**
    检测值是否有效
    */
    private class func isValueEnable(value:CGFloat)->Bool{
        if(value<DisableConstrainsValueMAX-1&&value>=DisableConstrainsValueMIN+1){
            return true;
        }
        return false;
    }
   
}
