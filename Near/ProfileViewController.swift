//
//  ProfileViewController.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ProfileViewDelegate {
    
    private var user: User? = nil
    private var isCurrentUser: Bool!
    private var profileV: ProfileView!
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.profileV.reload()
    }
    
    private func setUP() {
        profileV = ProfileView(frame: self.view.frame, isCurrentUser: self.isCurrentUser)
        profileV.delegate = self
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
        guard User.currentUser.userName != self.user!.userName else {
            return
        }
        
        guard parent?.getClassName() == nil else {
            navBar = (parent as! UINavigationController).navigationBar
            return
        }
        
        for i in navBar.subviews {
            guard let navView = i as? NearNavigationView else {
                continue
            }
            for v in navView.subviews {
                v.userInteractionEnabled = true
                v.hidden = false
            }
            navView.hidden = false
        }
    }
    
    func profileView(tapEdit sender: UIView) {
        let profileEditVC = ProfileEditingViewController()
        for i in (self.navigationController?.navigationBar.subviews)! {
            guard let navView = i as? NearNavigationView else {
                continue
            }
            for v in navView.subviews {
                v.userInteractionEnabled = false
                v.hidden = true
            }
            navView.hidden = true
        }
        self.navigationController?.pushViewController(profileEditVC, animated: true)
    }
    
}
