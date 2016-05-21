//
//  GeneralViewController.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/20.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class GeneralViewController: UIViewController {
    
    private let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    private let generalVM = GeneralViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setPageViewController()
        
        setNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setPageViewController() {
        
        let startingViewController = MainTimeLineViewController()
        let viewControllers = [startingViewController]
        
        pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        pageViewController.view.frame = self.view.frame
        pageViewController.dataSource = generalVM
        pageViewController.delegate = generalVM
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
        
        for v in pageViewController.view.subviews {
            if v.isKindOfClass(UIScrollView) {
                (v as! UIScrollView).delegate = generalVM
            }
        }
    }
    
    //============set navigationBar============
    
    let navBarView = UIView()
    let navBarBackgroundColor: UIColor = UIColor.whiteColor()
    
    func setNavigationBar() {
        
        navBarView.backgroundColor = navBarBackgroundColor
        
        let orange = UIColor(red: 255/255, green: 69.0/255, blue: 0.0/255, alpha: 1.0)
        let gray = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0)
        
        let leftImageView = UIImageView.setImageViewWithSetAlwaysRenderingMode("prof_pre")
        leftImageView.tintColor = hogeColoring()
        let centerImageView = UIImageView.setImageViewWithSetAlwaysRenderingMode("timeline_pre")
        centerImageView.tintColor = orange
        let rightImageView = UIImageView.setImageViewWithSetAlwaysRenderingMode("messa_pre")
        rightImageView.tintColor = hogeColoring()
        let navItems = [leftImageView, centerImageView, rightImageView]
        
        generalVM.navItems = navItems
        
        setNavBarViewItem(navBarView, items: navItems)

        self.navigationController?.navigationBar.addSubview(navBarView)
        self.navigationController?.navigationBar.translucent = false
    }
    
    func setNavBarViewItem(navBarView: UIView, items: [UIView]) {
        for (i, v) in items.enumerate() {
            let screenSize = UIScreen.mainScreen().bounds.size
            let originX = (screenSize.width/2.0 - v.frame.size.width/2) + CGFloat(i * 100) - 100
            v.frame.origin = CGPoint(x: originX, y: 8)
            v.tag = i //tapAction
            let tapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(GeneralViewController.tapOnHeader))
            v.addGestureRecognizer(tapGestureRecog)
            v.userInteractionEnabled = true
            navBarView.addSubview(v)
        }
    }
    
    func tapOnHeader() {
        
    }
    
    func hogeColoring() -> UIColor{
        let t = 1
        
        let orange = UIColor(red: 255/255, green: 69.0/255, blue: 0.0/255, alpha: 1.0)
        let gray = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0)
        
        let cgInit = CGColorGetComponents(orange.CGColor)
        let cgGoal = CGColorGetComponents(gray.CGColor)
        
        
        let r = cgInit[0] + CGFloat(t) * (cgGoal[0] - cgInit[0])
        let g = cgInit[1] + CGFloat(t) * (cgGoal[1] - cgInit[1])
        let b = cgInit[2] + CGFloat(t) * (cgGoal[2] - cgInit[2])
        print(r, g, b)
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    } // 動きに合わせて色を返す CGFloatで動的にしている。


}
