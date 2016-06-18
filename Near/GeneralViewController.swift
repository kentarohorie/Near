//
//  GeneralViewController.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/20.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit
import FBSDKLoginKit

@objc protocol GeneralViewControllerDelegate {
    func generalViewController(viewDidLoad sender: UIViewController)
}

class GeneralViewController: UIViewController, FBLoginViewModeldelegate, GeneralViewModelDelegate {
    
    private let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    private let generalVM = GeneralViewModel()
    private let fbLoginVM = FBLoginViewModel()
    private let noLocationView = UIView()
    
    internal var delegate: GeneralViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate?.generalViewController(viewDidLoad: self)
        generalVM.generalViewController(viewDidLoad: self)
        generalVM.delegate = self
        
        setNoLocationView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    internal func generalViewModel(didGetLocation sender: NSObject) {
        noLocationView.removeFromSuperview()
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("already login")
            User.fetchFromAPI({
                print("complete fetch from api")
                self.setPageViewController()
                self.setNavigationBar()
                
                User.sampleSetUP()
            })
        } else {
            print("yet login")
            setFBLoginView()
        }
    }
    

    
    internal func fbLoginViewModel(didFetchFBDataAndSetData vm: NSObject) {
        self.setPageViewController()
        self.setNavigationBar()
        
        User.sampleSetUP()
    }
    
    private func setNoLocationView() {
        noLocationView.frame = self.view.frame
        noLocationView.backgroundColor = UIColor.redColor()
        self.view.addSubview(noLocationView)
    }
    
    private func setFBLoginView() {
        let fbLoginView = FBLoginView(frame: view.frame, delegate: fbLoginVM)
        fbLoginVM.customDelegate = self
        self.view.addSubview(fbLoginView)
    }
    
    
    //============ set pageviewcontroller ==========
    
    private func setPageViewController() {
        
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
    
    private func setNavigationBar() {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: (self.navigationController?.navigationBar.frame.height)!)
        let navBarView = NearNavigationView(frame: frame, imageNames: ["prof_nav", "location_nav", "message_nav"], firstIndex: 1)
        let navBarColor = UIColor(red: 0, green: 187/255, blue: 211/255, alpha: 1)
        navBarView.backgroundColor = navBarColor
        self.navigationController?.navigationBar.barTintColor = navBarColor
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
