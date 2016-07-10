//
//  MessageListViewController.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class MessageListViewController: UIViewController, MessageListViewModelDelegate, MessageViewControllerDelegate {

    let messageListVM = MessageListViewModel()
    var messageListV: MessageListView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        setUP()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUP()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUP() {
        messageListV = UINib(nibName: "MessageListView", bundle: nil).instantiateWithOwner(self, options: nil).first as! MessageListView
        messageListV.tableView.delegate = messageListVM
        messageListV.tableView.dataSource = messageListVM
        
        self.view = messageListV

        messageListVM.delegate = self
    }
    
    // ========delegate method ==============
    
    func didTapMessageLiestViewTableViewCell(room: MessageRoom) {
        let messageVC = MessageViewController(room: room, opponentUser: room.opponentUser, isFromProfile: false)
        messageVC.myDelegate = self

        for i in (self.navigationController?.navigationBar.subviews)! {
            if let navView = i as? NearNavigationView {
                for v in navView.subviews {
                    v.userInteractionEnabled = false
                    v.hidden = true
                }
                navView.hidden = true
            }
        }
        
        self.navigationController?.pushViewController(messageVC, animated: true)
    }
    
    func messageViewController(sentMessage sender: LGChatController) {
        messageListV.tableView.reloadData()
    }
}
