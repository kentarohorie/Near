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
        //==upload image to s3 test
        let uploadFileURL = editingInfo![UIImagePickerControllerReferenceURL] as! NSURL
        let imageName = uploadFileURL.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
        
        // getting local path
        let localPath = (documentDirectory as NSString).stringByAppendingPathComponent(imageName!)
        
        
        //getting actual image
        let image = editingInfo![UIImagePickerControllerOriginalImage] as! UIImage
        let data = UIImagePNGRepresentation(image)
        data!.writeToFile(localPath, atomically: true)
        
        let imageData = NSData(contentsOfFile: localPath)!
        let imageURL = NSURL(fileURLWithPath: localPath)
        
        let S3BucketName: String = "nearfornearinc"
        let S3UploadKeyName: String = "public/fuga.png"
        
        let transferUtility = AWSS3TransferUtility.defaultS3TransferUtility()
        let expression = AWSS3TransferUtilityUploadExpression()

        transferUtility.uploadFile(imageURL, bucket: S3BucketName, key: S3UploadKeyName, contentType: "image/png", expression: expression, completionHander: nil).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            if let exception = task.exception {
                print("Exception: \(exception.description)")
            }
            if let _ = task.result {
                print("Upload Starting!")
            }
            
            return nil;
        }
        
        //=================================

        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
