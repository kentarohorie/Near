//
//  MessageListTableViewCell.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/10.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class MessageListTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var newMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUP()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUP() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 10
        avatarImageView.clipsToBounds = true
        self.selectionStyle = .None
    }
    
}
