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