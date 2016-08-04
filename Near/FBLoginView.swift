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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var agreementView: UIView!
    
    override func awakeFromNib() {
        let screenBounds = UIScreen.mainScreen().bounds
        loginButton = FBSDKLoginButton()
        loginButton.center = CGPoint(x: screenBounds.width / 2, y: screenBounds.height / 2)
        self.addSubview(loginButton)
        
        self.bringSubviewToFront(agreementView)
        textView.layer.cornerRadius = 10
        agreementView.hidden = true
    }
    
    @IBAction func tapButton(sender: AnyObject) {
        self.bringSubviewToFront(textView)
        agreementView.hidden = false
    }
    
    @IBAction func tapCloseButton(sender: AnyObject) {
        agreementView.hidden = true
    }
}
