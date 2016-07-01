//
//  HogeViewController.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/06/25.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

@objc protocol ProfileEditingViewControllerDelegate {
    func profileEditingViewController(tapDone sender: UIViewController)
}

class ProfileEditingViewController: UIViewController, ProfileEditViewDelegate {
    internal var delegate: ProfileEditingViewControllerDelegate?
    
    private let profileEditVM = ProfileEditViewModel()
    private var profileEditV: ProfileEditView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setNavBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setView() {
        profileEditV = UINib(nibName: "ProfileEditView", bundle: nil).instantiateWithOwner(self, options: nil).first as! ProfileEditView
        profileEditV.delegate = profileEditVM
        profileEditV.delegate = self
        profileEditVM.delegate = profileEditV
        self.view = profileEditV
    }
    
    var navBar: UINavigationBar!
    
    override func didMoveToParentViewController(parent: UIViewController?) {
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
    
    func profileEditView(tapEditImage sender: UIView, isMain: Bool, subImageName: String) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = profileEditVM
            profileEditVM.isMainForImage = isMain
            profileEditVM.subImageName = subImageName
            presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }
    
    private func setNavBar() {
        let button = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(ProfileEditingViewController.tapDoneButton))
        self.navigationItem.setRightBarButtonItem(button, animated: true)
    }
    
    func tapDoneButton() {
        profileEditV.setInputDataToUser()
        profileEditVM.profileEditingViewController(tapDone: self)
        delegate?.profileEditingViewController(tapDone: self)
    }
    
}