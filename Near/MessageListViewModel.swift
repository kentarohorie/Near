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
    
    let users = User.sampleSetUP()
    let messages = ["ご飯いかない？", "はじめまして！", "いや。。。ﾑﾘ。。。"]
    
    
    //======================================
    //              TableView setting
    //======================================
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count - 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageListTableViewCell", forIndexPath: indexPath) as! MessageListTableViewCell
        let avatarImage = users[indexPath.row + 3].avatar!//UIImage(named: "\(userSampleImage[indexPath.row])")
        cell.avatarImageView.image = avatarImage
        cell.userNameLabel.text = users[indexPath.row].userName//userSampleName[indexPath.row]
        cell.newMessageLabel.text = messages[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didTapMessageLiestViewTableViewCell!()
    }
    
}
