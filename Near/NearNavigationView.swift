//
//  NearNavigationView.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/21.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

@objc protocol NearNavigationViewDelegate {
    optional func tapNavigationImageView(index: Int)
}

class NearNavigationView: UIView {
    
    internal var viewColor: UIColor = UIColor.whiteColor()
    internal var delegate: NearNavigationViewDelegate?
    
    private var items: [UIView] = []
    private var firstNavItemIndex: Int!
    
    init(frame: CGRect, imageNames: [String], firstIndex: Int) {
        super.init(frame: frame)
        
        firstNavItemIndex = firstIndex
        setUP(imageNames)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func getItems() -> [UIView]? {
        return items
    }
    
    private func setUP(imageNames: [String]) {
        self.backgroundColor = viewColor
        setImageViewsToItems(imageNames) {
            self.setNavItemsToView()
        }
    }
    
    private func setNavItemsToView() {
        for (i, v) in items.enumerate() {
            let screenSize = UIScreen.mainScreen().bounds.size
            let distance = 150
            let originX = (screenSize.width/2.0 - v.frame.size.width/2) + CGFloat(i * distance) - CGFloat(distance)
            v.frame.origin = CGPoint(x: originX, y: 0)
            v.tag = i
            let tapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(NearNavigationView.tapOnHeader(_:)))
            v.addGestureRecognizer(tapGestureRecog)
            v.userInteractionEnabled = true
            self.addSubview(v)
        }
    }
    
    private func setImageViewsToItems(imageNames: [String], callback: () -> Void) {
        for (i, name) in imageNames.enumerate() {
            let imageView = UIImageView.setImageViewWithSetAlwaysRenderingMode(name)
            imageView.frame.size = CGSize(width: 50, height: 50)
            imageView.tintColor = UIColor.appCustomDefaultGray()
            if i == firstNavItemIndex {
                imageView.tintColor = UIColor.customOrange()
            }
            self.items.append(imageView)
        }
        callback()
    }
    
    @objc private func tapOnHeader(sender: UITapGestureRecognizer) {
        delegate?.tapNavigationImageView!(sender.view!.tag)
    }
    
    
    
}


