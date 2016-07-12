//
//  FBLoginView.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/06/10.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FBLoginView: UIView {
    var loginButton: FBSDKLoginButton!
    
    override func awakeFromNib() {
        loginButton = FBSDKLoginButton()
        loginButton.center = self.center
        
        self.addSubview(loginButton)
    }
    
}
