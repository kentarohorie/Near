//
//  ProfileViewController.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var user: User? = nil
    private var isCurrentUser: Bool!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(user: User, isCurrentUser: Bool) {
        self.init(nibName: nil, bundle: nil)
        self.user = user
        self.isCurrentUser = isCurrentUser
        setUP()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUP()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setUP() {
        let profileV = ProfileView(frame: self.view.frame, isCurrentUser: self.isCurrentUser)
        self.view = profileV
        
        guard let user = self.user else {
            return
        }
        let profileVM = ProfileViewModel(user: user)
        profileVM.delegate = profileV
        profileVM.setUserToView()
    }
    
    
    var navBar: UINavigationBar!
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        if User.currentUser.userName == self.user!.userName {
            
        } else {
        guard parent?.getClassName() == nil else {
            navBar = (parent as! UINavigationController).navigationBar
            return
        }
        for i in navBar.subviews {
            if let navView = i as? NearNavigationView {
                for v in navView.subviews {
                    v.userInteractionEnabled = true
                    v.hidden = false
                }
                navView.hidden = false
            }
        }
        }
    }

    
}
