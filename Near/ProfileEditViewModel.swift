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
    func profileEditVM(completeEdit sender: NSObject)
}

class ProfileEditViewModel: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    internal var delegate: ProfileEditViewModelDelegate?
    internal var isMainForImage: Bool = true
    internal var subImageName: String = ""
    
    private var mainImageFileURL: NSURL?
    private var subImageFileURLDicArray: [[String: AnyObject]] = []
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let uploadFileURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let subImageNum = Int(subImageName)
        
        if isMainForImage {
            User.currentUser.avatar = image
            mainImageFileURL = uploadFileURL
        } else {
            User.currentUser.subImages[subImageNum!] = image
            subImageFileURLDicArray.append(["fileURL": uploadFileURL, "num": subImageNum!])
        }
    
        delegate?.profileEditVM(didChangeImage: self)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func profileEditingViewController(tapDone sender: UIViewController) {
        let user = User.currentUser
        var work = "", school = "", greetingMessage = ""
        if user.work != nil {
            work = user.work!
        }
        
        if user.school != nil {
            school = user.school!
        }
        
        if user.greetingMessage != nil {
            greetingMessage = user.greetingMessage!
        }
        User.updateUserWithAPI(user.age!, name: user.userName!, latitude: User.coordinate[0], longitude: User.coordinate[1], loginTime: user.loginTime!, school: school, work: work, greetingMessage: greetingMessage) {
            print("updating ..... complete!")
            self.delegate?.profileEditVM(completeEdit: self)
        }
        if let mainFileURL = mainImageFileURL {
            User.uploadImageToS3(mainFileURL, image: User.currentUser.avatar!, uploadImageName: "", isMain: true) {
                print("updated main image to s3 ")
            }
        }
        
        for (i, fileURLDic) in subImageFileURLDicArray.enumerate() {
            let url = fileURLDic["fileURL"] as! NSURL
            let subImageNum = fileURLDic["num"] as! Int
            let image = User.currentUser.subImages[subImageNum]
            User.uploadImageToS3(url, image: image!, uploadImageName: String(subImageNum), isMain: false) {
                if i == (self.subImageFileURLDicArray.count - 1) {
                    print("updated sub image to s3 ")
                }
            }
        }
    }

}
