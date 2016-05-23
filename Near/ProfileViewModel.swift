//
//  ProfileViewModel.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

@objc protocol ProfileViewModelDelegate {
    func setUser(user: User)
}

class ProfileViewModel: NSObject {
    internal var delegate: ProfileViewModelDelegate?
    var user: User?
    
    init(user: User) {
        self.user = user
    }
    
    func setUserToView() {
        delegate?.setUser(user!)
    }
    
}

//name.text = "Kentar Horie"
//greetingMessage.text = "よろしく〜"
//age.text = "21歳"
//company.text = "Google inc,"
//university.text = "福島大学"
//address.text = "大阪市"
//relationship.text = "アン・ハサウェイと交際中"
//location.textcoverImage: UIImage, avatarImage: UIImage, name: String, greetingMessage: String, age: String, company: String, university: String, address: String, relationship: String, location: String, fbImages: [UIImage]
