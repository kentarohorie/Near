//
//  ProfileViewController.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let profileVM = ProfileViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        setUP()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUP() {
        let profileV = UINib(nibName: "ProfileView", bundle: nil).instantiateWithOwner(self, options: nil).first as! ProfileView
        self.view = profileV
    }
    
}
