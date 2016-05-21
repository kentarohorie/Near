//
//  GeneralViewController.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/20.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class GeneralViewController: UIViewController {
    
    private let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    private let generalVM = GeneralViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setPageViewController()
        setNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //============ set pageviewcontroller ==========
    
    func setPageViewController() {
        
        let startingViewController = MainTimeLineViewController()
        let viewControllers = [startingViewController]
        
        pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        pageViewController.view.frame = self.view.frame
        pageViewController.dataSource = generalVM
        pageViewController.delegate = generalVM
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
        
        for v in pageViewController.view.subviews {
            if v.isKindOfClass(UIScrollView) {
                (v as! UIScrollView).delegate = generalVM
            }
        }
    }
    
    //============ set navigationBar ============
    
    func setNavigationBar() {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: (self.navigationController?.navigationBar.frame.height)!)
        let navBarView = NearNavigationView(frame: frame, imageNames: ["prof_pre", "timeline_pre", "messa_pre"], firstIndex: 1)
        navBarView.delegate = generalVM
        generalVM.navItems = navBarView.getItems()
        generalVM.pageVC = self.pageViewController
        

        self.navigationController?.navigationBar.addSubview(navBarView)
        self.navigationController?.navigationBar.translucent = false
    }

}
