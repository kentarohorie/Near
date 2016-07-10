//
//  MessageViewController.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/10.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

@objc protocol MessageViewControllerDelegate {
    func messageViewController(sentMessage sender: LGChatController)
}

class MessageViewController: LGChatController, LGChatControllerDelegate {

    internal var myDelegate: MessageViewControllerDelegate?
    
    private let messageVM = MessageViewModel()
    private var room: MessageRoom!
    private var userMessages: [LGChatMessage] = []
    private var opponentUser: User!
    private var isFromProfile: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(room: MessageRoom, opponentUser: User, isFromProfile: Bool) {
        self.init(nibName: nil, bundle: nil)
        self.messages = room.messages
        self.opponentUser = opponentUser
        self.isFromProfile = isFromProfile
        self.room = room
        setUP()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    private func setUP() {
        setController()
        setUser()
    }
    
    private func setController() {
        self.delegate = self
    }
    
    private func setUser() {
//        self.title = "Anne Hathaway"   文字が黒
        self.opponentImage = opponentUser.avatar
    }
    
    //======== LGChatControllerDelegate ==============
    
    func shouldChatController(chatController: LGChatController, addMessage message: LGChatMessage) -> Bool {
        room.messages.append(LGChatMessage(content: message.content, sentBy: .User))
        MessageRoomManager.createSenderMessageToRoomWithAPI(message.content, userID: User.currentUser.fbID!, roomID: room.roomID, callback: nil)
        myDelegate?.messageViewController(sentMessage: self)
        return true
    }
        
    //========= back navigation action ==========
    
    var navBar: UINavigationBar!
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        guard !(isFromProfile) else {
            return
        }
        
        guard parent?.getClassName() == nil else {
            navBar = (parent as! UINavigationController).navigationBar
            return
        }
        
        for i in navBar.subviews {
            if let navView = i as? NearNavigationView {
                for v in navView.subviews {
                    v.userInteractionEnabled = true
                    v.hidden = false
                }
                navView.hidden = false
            }
        }
    }

}
