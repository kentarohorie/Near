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
        
        let leftImageView = UIImageView.setImageViewWithSetAlwaysRenderingMode("prof_pre")
        leftImageView.tintColor = UIColor.grayColor()
        let centerImageView = UIImageView.setImageViewWithSetAlwaysRenderingMode("timeline_pre")
        centerImageView.tintColor = UIColor.grayColor()
        let rightImageView = UIImageView.setImageViewWithSetAlwaysRenderingMode("messa_pre")
        rightImageView.tintColor = UIColor.grayColor()
        let navItems = [leftImageView, centerImageView, rightImageView]
        
        generalVM.navItems = navItems
        
        setNavBarViewItem(navBarView, items: navItems)

        self.navigationController?.navigationBar.addSubview(navBarView)
    }
    
    func setNavBarViewItem(navBarView: UIView, items: [UIView]) {
        for (i, v) in items.enumerate() {
            let screenSize = UIScreen.mainScreen().bounds.size
            let originX = (screenSize.width/2.0 - v.frame.size.width/2) + CGFloat(i * 100)
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

}
