
//
//  GeneralViewModel.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/20.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class GeneralViewModel: NSObject, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate, NearNavigationViewDelegate {
    
    internal var navItems: [UIView]?
    internal var pageVC: UIPageViewController?
    
    private var navBarView: UIView?
    private var currentPage: String = "MainTimeLineViewController"
    private var isTouching = true
    private let orange = UIColor.customOrange()
    private let gray = UIColor.customGray()
    private var isTapNavBar = false
    private var isForward = false
    
    internal func tapNavigationImageView(index: Int) {
        var vc: UIViewController?
        var direction: UIPageViewControllerNavigationDirection = .Forward
        if currentPage == "MainTimeLineViewController" {
            switch index {
            case 0:
                vc = ProfileViewController(user: User.currentUser)
                direction = .Reverse
                isForward = false
                currentPage = "ProfileViewController"
            case 1:
                break
            case 2:
                vc = MessageListViewController()
                direction = .Forward
                isForward = true
                currentPage = "MessageListViewController"
            default:
                break
            }
        } else if currentPage == "ProfileViewController" {
            switch index {
            case 0:
                break
            case 1:
                vc = MainTimeLineViewController()
                direction = .Forward
                isForward = true
                currentPage = "MainTimeLineViewController"
            default:
                break
            }
        } else if currentPage == "MessageListViewController" {
            switch index {
            case 1:
                vc = MainTimeLineViewController()
                direction = .Reverse
                isForward = false
                currentPage = "MainTimeLineViewController"
            case 2:
                break
            default:
                break
            }
        }
        
        guard let unwrapvc = vc else {
            return
        }
        isTapNavBar = true
        pageVC?.setViewControllers([unwrapvc], direction: direction, animated: true, completion: nil)
    }
    
    internal func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let navItems = self.navItems else {
            return
        }
        
        isTouching = true
        
        var xOffset = scrollView.contentOffset.x //ここを動いた分だけとるように変更
        
        if currentPage == "ProfileViewController" {
            xOffset -= UIScreen.mainScreen().bounds.width / 3 + 250
        } else if currentPage == "MessageListViewController" {
            xOffset += UIScreen.mainScreen().bounds.width / 3 + 250
        }
        
        if !(isTouching) {
            if xOffset == 500 {
                xOffset = 750
            } else if xOffset == 250 {
                xOffset = 0
            }
        }
        
        if isTapNavBar {
            if isForward {
                xOffset -= 375
            } else {
                xOffset += 375
            }
        }
        
        let distance = CGFloat(150)
        
        for (i, v) in self.navItems!.enumerate() {
            let vSize = v.frame.size
            let originX = self.getOriginX(vSize, idx: CGFloat(i), distance: CGFloat(distance), xOffset: xOffset)
            v.frame.origin = CGPoint(x: originX, y: 0)
        }
        
        for imgV in navItems {
            var c = gray
            let originX = Double(imgV.frame.origin.x)
            
            if (originX > 71.5 && originX < 171.5) {
                c = self.gradient(originX, topX: 72.5, bottomX: 170.5, initC: orange, goal: gray)
            }
            else if (originX > 171.5 && originX < 271.5) {
                c = self.gradient(originX, topX: 172.5, bottomX: 270.5, initC: gray, goal: orange)
            }
            else if(originX == 171.5) {
                c = orange
            }
            imgV.tintColor = c
        }
        
        isTouching = false
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        isTapNavBar = false
    }
    
    private func getOriginX(vSize: CGSize, idx: CGFloat, distance: CGFloat, xOffset: CGFloat) -> CGFloat {
        
        //真ん中の配置
        var result = UIScreen.mainScreen().bounds.width / 2.0 - vSize.width/2.0
        //真ん中のアイコンからの距離
        result += (idx * distance)
        result -= xOffset / (UIScreen.mainScreen().bounds.width / distance)
        return result
    }
    
    private func gradient(percent: Double, topX: Double, bottomX: Double, initC: UIColor, goal: UIColor) -> UIColor{
        
        //1 or 0(右、左）
        let t = (percent - bottomX) / (topX - bottomX)
        
        let cgInit = CGColorGetComponents(initC.CGColor)
        let cgGoal = CGColorGetComponents(goal.CGColor)

        let r = cgInit[0] + CGFloat(t) * (cgGoal[0] - cgInit[0])
        let g = cgInit[1] + CGFloat(t) * (cgGoal[1] - cgInit[1])
        let b = cgInit[2] + CGFloat(t) * (cgGoal[2] - cgInit[2])
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    
    //========= pageviewcontroller delegate ===========
    
    internal func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let currentVC = pageViewController.viewControllers![0]
            currentPage = currentVC.getClassName()
        }
    }
    
    //========= pageviewcontroller datasource ===========
    
    internal func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let className = viewController.getClassName()
        
        if className == "MainTimeLineViewController" {
            return ProfileViewController(user: User.currentUser)
        } else if className == "MessageListViewController" {
            return MainTimeLineViewController()
        } else {
            return nil
        }
    }
    
    internal func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
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
