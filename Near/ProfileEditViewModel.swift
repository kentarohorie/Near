//
//  ProfileEditViewModel.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/06/25.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

@objc protocol ProfileEditViewModelDelegate {
    func profileEditVM(didChangeImage sender: NSObject)
}

class ProfileEditViewModel: NSObject, ProfileEditViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    internal var delegate: ProfileEditViewModelDelegate?
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        User.currentUser.avatar = image
        delegate?.profileEditVM(didChangeImage: self)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

}
