//
//  MainTimeLineViewTableViewCell.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class MainTimeLineViewTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatarIMageView: UIImageView!
    @IBOutlet weak var userAgeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUP()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUP() {
        userAvatarIMageView.layer.cornerRadius = userAvatarIMageView.frame.width / 10
        userAvatarIMageView.clipsToBounds = true
        self.layer.borderColor = UIColor.grayColor().CGColor
    }
    
}
