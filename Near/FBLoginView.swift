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
    
    init(frame: CGRect, delegate: FBSDKLoginButtonDelegate) {
        super.init(frame: frame)
        loginButton = FBSDKLoginButton()
        loginButton.center = self.center
        loginButton.delegate = delegate
        loginButton.readPermissions = ["public_profile"] //学歴、居住地は各々が埋めるものにすべきかも 
                                                         //facebookの許可が必要
        self.addSubview(loginButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
