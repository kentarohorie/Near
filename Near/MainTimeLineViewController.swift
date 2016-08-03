//
//  MainTimeLineViewController.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class MainTimeLineViewController: UIViewController, MainTimeLineViewModelDelegate {
    
    var mainTimeLineVM = MainTimeLineViewModel()
    var childViewTableView: UITableView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    override func viewWillAppear(animated: Bool) {
        guard let tableView = self.childViewTableView else {
            return
        }
        
        mainTimeLineVM.users = User.timeLineUsers
        tableView.reloadData()
    }
    
    func setUP() {
        let mainTimeLineV = UINib(nibName: "MainTimeLineView", bundle: nil).instantiateWithOwner(self, options: nil).first as! MainTimeLineView
        self.childViewTableView = mainTimeLineV.tableView
        mainTimeLineV.tableView.delegate = mainTimeLineVM
        mainTimeLineV.tableView.dataSource = mainTimeLineVM
        mainTimeLineVM.delegate = self
        
        self.view = mainTimeLineV
    }
    
    func didTapMainTimeLineTableViewCell(selectedUser: User) {
        let profileVC = ProfileViewController(user: selectedUser, isCurrentUser: false)
        for i in (self.navigationController?.navigationBar.subviews)! {
            if let navView = i as? NearNavigationView {
                for v in navView.subviews {
                    v.userInteractionEnabled = false
                    v.hidden = true
                }
                navView.hidden = true
            }
        }
        
        self.navigationController?.pushViewController(profileVC, animated: true)
    }

}
