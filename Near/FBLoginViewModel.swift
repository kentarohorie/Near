//
//  FBLoginViewModel.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/06/10.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON

@objc protocol FBLoginViewModeldelegate {
    func fbLoginViewModel(didFetchFBDataAndSetData vm: NSObject)
}

class FBLoginViewModel: NSObject, FBSDKLoginButtonDelegate {
    
    internal var customDelegate: FBLoginViewModeldelegate?
    
    internal func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        guard (error == nil) else {
            print("login error :\(error)")
            return
        }
        
        guard !(result.isCancelled) else {
            print("login cancelled")
            return
        }
        
        loginButton.readPermissions = ["public_profile"]
        fetchUserData()
    }
    
    internal func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user log out with facebook")
    }
    
    private func fetchUserData() {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, age_range,  gender, picture, education"])
        
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            guard (error == nil) else {
                print("fetch error with facebook: \(error)")
                return
            }
            
            let name = JSON(result)["name"].string
            let gender = JSON(result)["gender"].string
            let id = JSON(result)["id"].string
            var age = 0
            if let minAge = (JSON(result)["age_range"]["min"].int) {
                age = minAge
            } else if let maxAge = (JSON(result)["age_range"]["max"].int) {
                age = maxAge
            }
            
            User.createUserWithAPI(id!, gender: gender!, age: age, name: name!, callback: {
                User.fetchFromAPI({
                    self.customDelegate?.fbLoginViewModel(didFetchFBDataAndSetData: self)
                })
            })
        }
    }
}