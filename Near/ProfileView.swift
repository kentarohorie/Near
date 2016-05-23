//
//  ProfileView.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class ProfileView: UIView, ProfileViewModelDelegate {

    @IBOutlet weak var headerScrollView: UIScrollView!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var imageCoverView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var greetingMessage: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var university: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var relationship: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var fbImage1: UIImageView!
    @IBOutlet weak var fbImage2: UIImageView!
    @IBOutlet weak var fbImage3: UIImageView!
    @IBOutlet weak var messageButton: UIButton!
    
    override func awakeFromNib() {
        setUP()
    }
    
    func setUser(user: User) {
        setCoverImage(user.profileCoverImage!)
        userAvatarImageView.image = user.avatar
        name.text = user.userName
        greetingMessage.text = user.greetingMessage
        age.text = String(user.age!) + "歳"
        company.text = user.company!
        university.text = user.university
        address.text = user.address
        relationship.text = user.relationship
        location.text = user.location
        for (i, imgV) in [fbImage1, fbImage2, fbImage3].enumerate() {
            imgV.image = user.facebookETCImage![i]
        }
        
        if User.currentUser().userName == user.userName {
            messageButton.hidden = true
        }
    }
    
    private func setUP() {
        setProfImage()
    }
    
    private func setCoverImage(image: UIImage) {
        let imageView = UIImageView(image: image)//UIImage(named: "prof_cover_sample.jpg"))
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

    @IBAction func tapMessageButton(sender: UIButton) {
        
    }
}
