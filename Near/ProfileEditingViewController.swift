//
//  HogeViewController.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/06/25.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class ProfileEditingViewController: UIViewController, ProfileEditViewDelegate {
    private let profileEditVM = ProfileEditViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setView() {
        let profileEditV = UINib(nibName: "ProfileEditView", bundle: nil).instantiateWithOwner(self, options: nil).first as! ProfileEditView
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
    
    func profileEditView(tapEditImage sender: UIView) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = profileEditVM
            presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }
}