
//
//  GeneralViewModel.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/20.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class GeneralViewModel: NSObject, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
    
    var navItems: [UIView]?
    var navBarView: UIView?
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        let distance = CGFloat(100 + 0) //self.navigationSideItemsStyle.rawValue)
        for (i, v) in self.navItems!.enumerate() {
            let vSize    = v.frame.size
            let originX  = self.getOriginX(vSize, idx: CGFloat(i), distance: CGFloat(distance), xOffset: xOffset)
            v.frame.origin      = CGPoint(x: originX, y: 8)
        }
        
        for imgV in navItems! {
            var c = UIColor.grayColor()
            let originX = Double(imgV.frame.origin.x)
            print("====\(originX)")
            if (originX > 71.5 && originX < 171.5) {
                c = self.gradient(originX, topX: 46, bottomX: 144, initC: UIColor.orangeColor(), goal: UIColor.grayColor())
            }
            else if (originX > 171.5 && originX < 271.5) {
                c = self.gradient(originX, topX: 146, bottomX: 244, initC: UIColor.grayColor(), goal: UIColor.orangeColor())
            }
            else if(originX == 171.5){
                c = UIColor.orangeColor()
            }
            imgV.tintColor = c
        }
    }
    
    func getOriginX(vSize: CGSize, idx: CGFloat, distance: CGFloat, xOffset: CGFloat) -> CGFloat{
        var result = UIScreen.mainScreen().bounds.width / 2.0 - vSize.width/2.0
        result += (idx * distance)
        result -= xOffset / (UIScreen.mainScreen().bounds.width / distance)
        return result
    }
    
    func gradient(percent: Double, topX: Double, bottomX: Double, initC: UIColor, goal: UIColor) -> UIColor{
        let t = (percent - bottomX) / (topX - bottomX) //この計算式はどう算出されたのか？
        
        let cgInit = CGColorGetComponents(initC.CGColor)
        let cgGoal = CGColorGetComponents(goal.CGColor)
        
        
        let r = cgInit[0] + CGFloat(t) * (cgGoal[0] - cgInit[0])
        let g = cgInit[1] + CGFloat(t) * (cgGoal[1] - cgInit[1])
        let b = cgInit[2] + CGFloat(t) * (cgGoal[2] - cgInit[2])
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    } // 動きに合わせて色を返す CGFloatで動的にしている。
    
    

    
    //========= pageviewcontroller datasource ===========
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let className = viewController.getClassName()
        
        if className == "MainTimeLineViewController" {
            return ProfileViewController()
        } else if className == "MessageListViewController" {
            return MainTimeLineViewController()
        } else {
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let className = viewController.getClassName()
        
        if className == "MainTimeLineViewController" {
            return MessageListViewController()
        } else if className == "ProfileViewController" {
            return MainTimeLineViewController()
        } else {
            return nil
        }
    }
}
