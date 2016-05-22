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
        let messageVC = MessageViewController()

        let navBarView = self.navigationController?.navigationBar.subviews[1] as! NearNavigationView
        for v in navBarView.subviews {
            v.userInteractionEnabled = false
            v.hidden = true
        }
        navBarView.hidden = true
        
        self.navigationController?.pushViewController(messageVC, animated: true)
    }
}
