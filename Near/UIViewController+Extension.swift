//
//  UIViewController+Extension.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/20.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

extension UIViewController {
    func getClassName() -> String {
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
    }
}
