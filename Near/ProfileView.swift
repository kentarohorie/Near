//
//  ProfileView.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    @IBOutlet weak var headerScrollView: UIScrollView!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    override func awakeFromNib() {
        setUP()
    }
    
    func setUP() {
        setCoverImage()
        setProfImage()
    }
    
    func setCoverImage() {
        let imageView = UIImageView(image: UIImage(named: "prof_cover_sample.jpg"))
        imageView.frame = headerScrollView.frame
        headerScrollView.addSubview(imageView)
        
        //============== 複数カバーイメージを設定するときに =============
        //        let imageViewB = UIImageView(image: UIImage(named: "cat.jpg"))
        //        imageViewB.frame.size = headerScrollView.frame.size
        //        headerScrollView.contentSize = CGSize(width: self.frame.width * 2, height: headerScrollView.frame.height)
        //        imageViewB.frame.origin = CGPoint(x: self.frame.width, y: headerScrollView.frame.origin.y)
        //        headerScrollView.addSubview(imageViewB)
        //        headerScrollView.pagingEnabled = true
        //========================================================
    }
    
    func setProfImage() {
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.width / 2
        userAvatarImageView.clipsToBounds = true
    }
}
