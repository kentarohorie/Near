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
    
    
    //======================================
    //              TableView setting
    //======================================
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainTimeLineViewTableViewCell", forIndexPath: indexPath) as! MainTimeLineViewTableViewCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didTapMessageLiestViewTableViewCell!()
    }
    
}
