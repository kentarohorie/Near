//
//  MainTimeLineView.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class MainTimeLineView: UIView {

    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        setUP()
    }
    
    func setUP() {
        tableView.registerNib(UINib(nibName: "MainTimeLineViewTableViewCell", bundle: nil), forCellReuseIdentifier: "MainTimeLineViewTableViewCell")
    }

}
