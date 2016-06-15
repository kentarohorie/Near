//
//  UIColor+Extension.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/21.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

extension UIColor {
    class func customOrange() -> UIColor{
        return UIColor(red: 0, green: 150/255, blue: 166/255, alpha: 1)
    }
    
    class func customGray() -> UIColor {
        return UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.0) // not work well using .whitecolor()
    }
    
    class func appCustomDefaultGray() -> UIColor {
        let cgInit = CGColorGetComponents(UIColor.customOrange().CGColor)
        let cgGoal = CGColorGetComponents(UIColor.customGray().CGColor)
        
        let r = cgInit[0] + cgGoal[0] - cgInit[0]
        let g = cgInit[1] + cgGoal[1] - cgInit[1]
        let b = cgInit[2] + cgGoal[2] - cgInit[2]
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}