//
//  UIImageView+Extension.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/20.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

extension UIImageView {
    class func setImageViewWithSetAlwaysRenderingMode(name: String) -> UIImageView {
        let image = UIImage(named: name)?.imageWithRenderingMode(.AlwaysTemplate)
        let imageView = UIImageView(image: image)
        return imageView
    }
}
