//
//  ProfileEditView.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/06/25.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

@objc protocol ProfileEditViewDelegate {
    optional func profileEditView(tapEditImage sender: UIView)
}

class ProfileEditView: UIView, ProfileEditViewModelDelegate {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var workTextField: UITextField!
    @IBOutlet weak var SchoolTextField: UITextField!
    
    internal var delegate: ProfileEditViewDelegate?
    
    override func awakeFromNib() {
        let tapGestureRecog = UITapGestureRecognizer(target: self, action: "tapMainImageView")
        mainImageView.addGestureRecognizer(tapGestureRecog)
        mainImageView.userInteractionEnabled = true
        roundAllImageView()
        setImages()
    }
    
    func tapMainImageView() {
        delegate?.profileEditView?(tapEditImage: self)
    }
    
    internal func profileEditVM(didChangeImage sender: NSObject) {
        setImages()
        User.uploadImageTest()
    }
    
    private func setImages() {
        mainImageView.image = User.currentUser.avatar
        // other image set here
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
    
}
