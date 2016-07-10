//
//  MessageRoom.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/07/09.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MessageRoom: NSObject {
    var roomID: Int!
    var messages: [LGChatMessage] = []
    var opponentUser: User!
}
