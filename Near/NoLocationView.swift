//
//  NoLocationView.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/07/19.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class NoLocationView: UIView {

    override func awakeFromNib() {
        self.frame = UIScreen.mainScreen().bounds
    }
    @IBAction func tapPermitButton(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }

}
