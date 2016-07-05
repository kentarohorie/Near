//
//  MainTimeLineViewModel.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

@objc protocol MainTimeLineViewModelDelegate {
    optional func didTapMainTimeLineTableViewCell(selectedUser: User)
}

class MainTimeLineViewModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let users = User.timeLineUsers
    var delegate: MainTimeLineViewModelDelegate?
    //======================================
    //              TableView setting
    //======================================
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainTimeLineViewTableViewCell", forIndexPath: indexPath) as! MainTimeLineViewTableViewCell
        cell.userAvatarIMageView.image = users[indexPath.row].avatar //UIImage(named: "\(userSampleImage[indexPath.row])")
        cell.userNameLabel.text = users[indexPath.row].userName//userSampleName[indexPath.row]
        cell.greetingMessage.text = users[indexPath.row].greetingMessage!
        cell.locationLabel.text = String(users[indexPath.row].distanceFromCurrentUser!) + "m"
        cell.loginLabel.text = users[indexPath.row].loginTime
        cell.ageLabel.text = String(users[indexPath.row].age!) + "歳"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 101
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didTapMainTimeLineTableViewCell!(users[indexPath.row])
    }
    
}
