//
//  MainTimeLineViewModel.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class MainTimeLineViewModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let userSampleName = ["Amanda", "Emi", "May", "Kitty", "Ann", "Ema"]
    let userSampleImage = ["sample_user", "user_sample_2", "user_sample_3", "sample_user_4", "sample_user_5", "user_sample_6"]
    //======================================
    //              TableView setting
    //======================================
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainTimeLineViewTableViewCell", forIndexPath: indexPath) as! MainTimeLineViewTableViewCell
        cell.userAvatarIMageView.image = UIImage(named: "\(userSampleImage[indexPath.row])")
        cell.userNameLabel.text = userSampleName[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSampleName.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 101
    }
    
}
