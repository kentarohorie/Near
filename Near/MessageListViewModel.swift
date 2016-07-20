//
//  MessageListViewModel.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

@objc protocol MessageListViewModelDelegate {
    optional func didTapMessageLiestViewTableViewCell(room: MessageRoom)
}

class MessageListViewModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: MessageListViewModelDelegate?
    
    let rooms = MessageRoomManager.messageRooms
    
    
    //======================================
    //              TableView setting
    //======================================
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageListTableViewCell", forIndexPath: indexPath) as! MessageListTableViewCell
        cell.avatarImageView.image = rooms[indexPath.row].opponentUser.avatar
        cell.userNameLabel.text = rooms[indexPath.row].opponentUser.userName
        var recentMessage = ""
        if rooms[indexPath.row].messages.count != 0 {
            recentMessage = (rooms[indexPath.row].messages.last?.content)!
        }
        cell.newMessageLabel.text = recentMessage
        if ((rooms[indexPath.row].messages.last?.sentTime.isEmpty) != nil) {
            rooms[indexPath.row].messages.last?.sentTime = "0秒前"
        }
        cell.sentTimeLabel.text = rooms[indexPath.row].messages.last?.sentTime
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didTapMessageLiestViewTableViewCell!(rooms[indexPath.row])
    }
    
}
