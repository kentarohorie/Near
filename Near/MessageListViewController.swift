//
//  MessageListViewController.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class MessageListViewController: UIViewController, MessageListViewModelDelegate {

    let messageListVM = MessageListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUP()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUP() {
        let messageListV = UINib(nibName: "MessageListView", bundle: nil).instantiateWithOwner(self, options: nil).first as! MessageListView
        messageListV.tableView.delegate = messageListVM
        messageListV.tableView.dataSource = messageListVM
        
        self.view = messageListV
        
        messageListVM.delegate = self
    }
    
    func didTapMessageLiestViewTableViewCell() {
        self.performSegueWithIdentifier("ToMessageView", sender: self)
    }
}
