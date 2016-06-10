//
//  GeneralViewController.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/20.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class GeneralViewController: UIViewController {
    
    private let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    private let generalVM = GeneralViewModel()
    private let fbLoginVM = FBLoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("already login")
            setFBLoginView(nil) //fb fetch data test
        } else {
            print("yet")
//            setFBLoginView {
                            self.setPageViewController()
                            self.setNavigationBar()
                
                            User.sampleSetUP()
//            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setFBLoginView(callback: (() -> Void)?) {
        let fbLoginView = FBLoginView(frame: view.frame, delegate: fbLoginVM)
        self.view.addSubview(fbLoginView)
        
        guard let cb = callback else {
            return
        }
        cb()
    }
    
    //============ set pageviewcontroller ==========
    
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
    
    //============ set navigationBar ============
    
    func setNavigationBar() {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: (self.navigationController?.navigationBar.frame.height)!)
        let navBarView = NearNavigationView(frame: frame, imageNames: ["prof_nav", "location_nav", "message_nav"], firstIndex: 1)
        navBarView.backgroundColor = UIColor(red: 58/255, green: 58/255, blue: 60/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 58/255, green: 58/255, blue: 60/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
//        let navBarTitleLabel = UILabel(frame: CGRectZero)
//        navBarTitleLabel.text = self.navigationItem.title
//        navBarTitleLabel.textColor = UIColor.whiteColor()
//        navBarTitleLabel.sizeToFit()
//        self.navigationItem.titleView = navBarTitleLabel
        
        navBarView.delegate = generalVM
        generalVM.navItems = navBarView.getItems()
        generalVM.pageVC = self.pageViewController
        

        self.navigationController?.navigationBar.addSubview(navBarView)
        self.navigationController?.navigationBar.translucent = false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }

}
