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
    @IBOutlet weak var imageCoverView: UIView!
    
    override func awakeFromNib() {
        setUP()
    }
    
    private func setUP() {
        setCoverImage()
        setProfImage()
//        setProfImageCircle()
    }
    
    private func setCoverImage() {
        let imageView = UIImageView(image: UIImage(named: "prof_cover_sample.jpg"))
        imageView.frame = headerScrollView.frame
        imageView.contentMode = .ScaleAspectFill    
        headerScrollView.addSubview(imageView)
        
        //============== 複数カバーイメージを設定するときに ============
        //        let imageViewB = UIImageView(image: UIImage(named: "cat.jpg"))
        //        imageViewB.frame.size = headerScrollView.frame.size
        //        headerScrollView.contentSize = CGSize(width: self.frame.width * 2, height: headerScrollView.frame.height)
        //        imageViewB.frame.origin = CGPoint(x: self.frame.width, y: headerScrollView.frame.origin.y)
        //        headerScrollView.addSubview(imageViewB)
        //        headerScrollView.pagingEnabled = true
        //========================================================
    }
    
    private func setProfImage() {
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.width / 2
        userAvatarImageView.clipsToBounds = true
        
        imageCoverView.layer.cornerRadius = imageCoverView.frame.width / 2
        imageCoverView.clipsToBounds = true
    }
    
//    private func setProfImageCircle() {
//        let avatarFrame = userAvatarImageView.frame
//        let view = UIView()
//        view.frame.size = CGSize(width: avatarFrame.width + 10, height: avatarFrame.height + 10)
//        view.frame.origin = userAvatarImageView.bounds.origin
//        view.layer.cornerRadius = view.frame.width / 2
//        view.clipsToBounds = true
//        view.backgroundColor = UIColor.whiteColor()
//        self.addSubview(view)
//    }
}
