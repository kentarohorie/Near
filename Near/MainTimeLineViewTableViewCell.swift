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
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var greetingMessage: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
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
        self.selectionStyle = .None
    }
    
}
