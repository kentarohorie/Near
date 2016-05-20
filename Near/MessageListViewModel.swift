//
//  MessageListViewModel.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

@objc protocol MessageListViewModelDelegate {
    optional func didTapMessageLiestViewTableViewCell()
}

class MessageListViewModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: MessageListViewModelDelegate?
    let userSampleImage = ["sample_user", "user_sample_2", "user_sample_3", "sample_user_4", "sample_user_5", "user_sample_6"]
    let userSampleName = ["Amanda", "Emi", "May", "Kitty", "Ann", "Ema"]
    
    
    //======================================
    //              TableView setting
    //======================================
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userSampleImage.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageListTableViewCell", forIndexPath: indexPath) as! MessageListTableViewCell
        let avatarImage = UIImage(named: "\(userSampleImage[indexPath.row])")
        cell.avatarImageView.image = avatarImage
        cell.userNameLabel.text = userSampleName[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didTapMessageLiestViewTableViewCell!()
    }
    
}
