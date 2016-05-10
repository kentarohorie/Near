//
//  NSObject+UIView+Extension.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/10.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

extension UIView {
    func getSuperViewController() -> UIViewController {
        var baseView = UIApplication.sharedApplication().keyWindow?.rootViewController
        while ((baseView?.presentedViewController) != nil)  {
            baseView = baseView?.presentedViewController
        }
        
        return baseView!
    }
}