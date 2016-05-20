//
//  MainTimeLineViewController.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class MainTimeLineViewController: UIViewController {
    
    let mainTimeLineVM = MainTimeLineViewModel()
    
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
    
    func setUP() {
        let mainTimeLineV = UINib(nibName: "MainTimeLineView", bundle: nil).instantiateWithOwner(self, options: nil).first as! MainTimeLineView
        mainTimeLineV.tableView.delegate = mainTimeLineVM
        mainTimeLineV.tableView.dataSource = mainTimeLineVM
        
        self.view = mainTimeLineV
    }

}
