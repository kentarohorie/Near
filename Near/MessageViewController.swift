//
//  MessageViewController.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/10.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

class MessageViewController: LGChatController, LGChatControllerDelegate {

    let messageVM = MessageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUP()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func setUP() {
//        let messageV = UINib(nibName: "MessageView", bundle: nil).instantiateWithOwner(self, options: nil).first as! MessageView
//        self.view = messageV
        launchChatController()
    }
    
    
    func launchChatController() {
        self.opponentImage = UIImage(named: "sample_user")
        self.title = "Anne Hathaway"
        let helloWorld = LGChatMessage(content: "Hello", sentBy: .Opponent)
        let helloWorld2 = LGChatMessage(content: "Where you are now?", sentBy: .Opponent)
        self.messages = [helloWorld, helloWorld2]
        self.delegate = self
//        self.navigationController?.pushViewController(chatController, animated: true)
    }
    
    // MARK: LGChatControllerDelegate
    
    func chatController(chatController: LGChatController, didAddNewMessage message: LGChatMessage) {
        print("Did Add Message: \(message.content)")
    }
    
    func shouldChatController(chatController: LGChatController, addMessage message: LGChatMessage) -> Bool {
        /*
         Use this space to prevent sending a message, or to alter a message.  For example, you might want to hold a message until its successfully uploaded to a server.
         */
        return true
    }

}
