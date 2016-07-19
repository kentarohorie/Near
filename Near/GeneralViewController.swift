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
    private var progressingView = UIView()
    private var fbLoginView = FBLoginView()
    private var noLocationView: NoLocationView?
    
    internal var delegate: GeneralViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.generalViewController(viewDidLoad: self)
        generalVM.generalViewController(viewDidLoad: self)
        generalVM.delegate = self
        
        setProgressingView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    internal func generalViewModel(didGetLocation sender: NSObject) {
        if let v = noLocationView {
            v.removeFromSuperview()
        }
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("already login")
            User.fetchFromAPI({
                User.downLoadAllImageFromS3(User.currentUser) {
                    User.updateUserWithAPI(User.currentUser.age!, name: User.currentUser.userName!, latitude: User.coordinate[0], longitude: User.coordinate[1], loginTime: User.currentUser.loginTime!, school: User.currentUser.school, work: User.currentUser.work, greetingMessage: User.currentUser.greetingMessage, callback: {
                        User.getUsersForTimelineAPI({
                            MessageRoomManager.getRoomsAndMessagesWithAPI(User.currentUser.fbID!, callback: {
                                self.removeViewAnimation(self.progressingView) {
                                    self.setPageViewController()
                                    self.setNavigationBar()
                                }
                            })
                        })
                    })
                }
            })
        } else {
            print("yet login")
            setFBLoginView() //join (already login) process in fbLoginViewModel(didFetchFBDataAndSetData) method
        }
    }
    
    internal func generalViewModel(cannotGetLocation sender: NSObject) {
        setNoLocationView()
    }
    
    internal func generalViewModel(allowGetLocation sender: NSObject) {
        if noLocationView != nil {
            noLocationView!.removeFromSuperview()
            setProgressingView()
        }
    }
    
    internal func fbLoginViewModel(didFetchFBDataAndSetData vm: NSObject) {
        fbLoginView.removeFromSuperview()
        User.fetchFromAPI({
            User.downLoadAllImageFromS3(User.currentUser) {
                User.updateUserWithAPI(User.currentUser.age!, name: User.currentUser.userName!, latitude: User.coordinate[0], longitude: User.coordinate[1], loginTime: User.currentUser.loginTime!, school: User.currentUser.school, work: User.currentUser.work, greetingMessage: User.currentUser.greetingMessage, callback: {
                    User.getUsersForTimelineAPI({
                        MessageRoomManager.getRoomsAndMessagesWithAPI(User.currentUser.fbID!, callback: {
                            self.removeViewAnimation(self.progressingView) {
                                self.setPageViewController()
                                self.setNavigationBar()
                            }
                        })
                    })
                })
            }
        })
    }
    
    internal func fbLoginViewModel(didLogin sender: NSObject) {
        fbLoginView.removeFromSuperview()
    }
    
    private func setNoLocationView() {
        noLocationView = UINib(nibName: "NoLocationView", bundle: nil).instantiateWithOwner(self, options: nil).first as? NoLocationView
        self.view.addSubview(noLocationView!)
    }
    
    private func setProgressingView() {
        self.navigationController?.navigationBarHidden = true
        progressingView = UINib(nibName: "ProgressingView", bundle: nil).instantiateWithOwner(self, options: nil).first as! ProgressingView
        progressingView.frame.origin = CGPointZero
        progressingView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height + (self.navigationController?.navigationBar.frame.height)!)
        self.view.addSubview(progressingView)
    }
    
    private func removeViewAnimation(dView: UIView, callback: () -> Void) {
        UIView.animateWithDuration(0.2, animations: {
            dView.backgroundColor = dView.backgroundColor?.colorWithAlphaComponent(0)
            }) { (bool) in
                self.navigationController?.navigationBarHidden = false
                dView.removeFromSuperview()
                callback()
        }
    }
    
    private func setFBLoginView() {
        fbLoginView = UINib(nibName: "FBLoginView", bundle: nil).instantiateWithOwner(self, options: nil).first as! FBLoginView
        fbLoginView.frame.origin = CGPointZero
        fbLoginView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height + (self.navigationController?.navigationBar.frame.height)!)
        fbLoginView.loginButton.delegate = fbLoginVM // require
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
