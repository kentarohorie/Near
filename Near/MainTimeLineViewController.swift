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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUP()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUP() {
        let mainTimeLineV = UINib(nibName: "MainTimeLineView", bundle: nil).instantiateWithOwner(self, options: nil).first as! MainTimeLineView
        mainTimeLineV.tableView.delegate = mainTimeLineVM
        mainTimeLineV.tableView.dataSource = mainTimeLineVM
        
        self.view = mainTimeLineV
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
