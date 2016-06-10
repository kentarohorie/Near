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

class FBLoginViewModel: NSObject, FBSDKLoginButtonDelegate {
    
    internal func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        guard (error == nil) else {
            print("login error :\(error)")
            return
        }
        
        guard !(result.isCancelled) else {
            print("login cancelled")
            return
        }
        
        print("user login")
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
            
            print(JSON(result))
        }
    }
}