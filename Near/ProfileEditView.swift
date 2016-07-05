//
//  ProfileEditView.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/06/25.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

@objc protocol ProfileEditViewDelegate {
    optional func profileEditView(tapEditImage sender: UIView, isMain: Bool, subImageName: String)
}

class ProfileEditView: UIView, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var workTextField: UITextField!
    @IBOutlet weak var SchoolTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    internal var delegate: ProfileEditViewDelegate?
    
    private let user = User.currentUser
    
    override func awakeFromNib() {
        setGestureForImageView()
        roundAllImageView()
        setImages()
        setDelegate()
        setTextPlaceholder()
    }
    
    internal func setImages() {
        mainImageView.image = user.avatar
        for (i, imageV) in [imageView2, imageView3, imageView4, imageView5, imageView6].enumerate() {
            guard let image = user.subImages[i] else {
                user.subImages[i] = UIImage(named: "empty_user")
                imageV.image = user.subImages[i]
                continue
            }
            
            imageV.image = image
        }
    }
    
    private func setGestureForImageView() {
        let tapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(ProfileEditView.tapMainImageView))
        mainImageView.addGestureRecognizer(tapGestureRecog)
        mainImageView.userInteractionEnabled = true
        
        for (i, imageV) in [imageView2, imageView3, imageView4, imageView5, imageView6].enumerate() {
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(ProfileEditView.tapSubImageView(_:)))
            imageV.tag = i
            imageV.addGestureRecognizer(tapGR)
            imageV.userInteractionEnabled = true
        }
    }
    
    private func roundImageView(imgV: UIImageView) {
        imgV.layer.cornerRadius = imgV.frame.width / 20
        imgV.layer.masksToBounds = true
    }
    
    private func roundAllImageView() {
        let imgVArray = [mainImageView, imageView2, imageView3, imageView4, imageView5, imageView6]
        for i in imgVArray {
            roundImageView(i)
        }
    }
    
    private func setDelegate() {
        workTextField.delegate = self
        SchoolTextField.delegate = self
        ageTextField.delegate = self
        aboutTextView.delegate = self
        mainScrollView.delegate = self
    }
    
    private func setTextPlaceholder() {
        if let age = user.age {
            ageTextField.text = String(age)
        }
        
        if let school = user.school {
            SchoolTextField.text = school
        }
        
        if let work = user.work {
            workTextField.text = work
        }
        
        if let about = user.greetingMessage {
            aboutTextView.text = about
        }
    }
    
    func setInputDataToUser() {
        user.age = Int(ageTextField.text!)
        user.school = SchoolTextField.text
        user.work = workTextField.text
        user.greetingMessage = aboutTextView.text
    }
    
    //======= selector action method ======
    //=====================================
    
    func tapMainImageView() {
        delegate?.profileEditView?(tapEditImage: self, isMain: true, subImageName: "")
    }
    
    func tapSubImageView(sender: UITapGestureRecognizer) {
        delegate?.profileEditView?(tapEditImage: self, isMain: false, subImageName: "\(sender.view!.tag)")
    }
    
    //========== delegate method ==========
    //=====================================
    
    internal func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    internal func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        aboutTextView.resignFirstResponder()
        workTextField.resignFirstResponder()
        SchoolTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
    }
    
}
