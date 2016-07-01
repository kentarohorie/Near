//
//  ProfileEditViewModel.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/06/25.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit
import AWSS3

@objc protocol ProfileEditViewModelDelegate {
    func profileEditVM(didChangeImage sender: NSObject)
}

class ProfileEditViewModel: NSObject, ProfileEditViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    internal var delegate: ProfileEditViewModelDelegate?
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        User.currentUser.avatar = image
        delegate?.profileEditVM(didChangeImage: self)
        // カットした状態の画像をカットしたものとして受け取る工夫がいる。
        let uploadFileURL = editingInfo![UIImagePickerControllerReferenceURL] as! NSURL
        let image = editingInfo![UIImagePickerControllerOriginalImage] as! UIImage
        User.uploadImageToS3(uploadFileURL, image: image, uploadImageName: "sub1", isMain: false)

        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
        

}
