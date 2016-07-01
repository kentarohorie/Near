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
    internal var isMainForImage: Bool = true
    internal var subImageName: String = ""
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let uploadFileURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let subImageNum = Int(subImageName)
        
        if isMainForImage {
            User.currentUser.avatar = info[UIImagePickerControllerEditedImage] as! UIImage
            User.uploadImageToS3(uploadFileURL, image: image, uploadImageName: "", isMain: true)
        } else {
            User.currentUser.subImages[subImageNum!] = info[UIImagePickerControllerEditedImage] as! UIImage
            User.uploadImageToS3(uploadFileURL, image: image, uploadImageName: subImageName, isMain: false)
        }
        
        delegate?.profileEditVM(didChangeImage: self)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func profileEditingViewController(tapDone sender: UIViewController) {
        
    }

}
