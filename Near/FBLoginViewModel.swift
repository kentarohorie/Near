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

class FBLoginViewModel: NSObject, FBSDKLoginButtonDelegate {
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        guard (error == nil) else {
            print("login error :\(error)")
            return
        }
        
        guard !(result.isCancelled) else {
            print("login cancelled")
            return
        }
        
        print("user login")
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user log out with facebook")
    }
}
