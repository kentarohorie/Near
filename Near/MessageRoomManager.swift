//
//  MessageRoomManager.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/07/09.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MessageRoomManager: NSObject {
    static var messageRooms: [MessageRoom] = []
    
    private class func searchRoomWithID(ID: Int) -> MessageRoom? {
        // search room
        return nil
    }
    
    private class func getRooms(jrooms: [JSON]) -> [MessageRoom] {
        var rooms: [MessageRoom] = []
        for jroom in jrooms {
            let room = MessageRoom()
            let messages = getMessages(jroom["messages"].array!)
            let juser = jroom["opponentUser"]
            var greetingMessage = ""
            if juser["greetingMessage"] != nil {
                greetingMessage = juser["greetingMessage"].string!
            }
            let oppoentUser = User.getUser(juser["name"].string!, age: juser["age"].int!, fbID: juser["fbID"].string!, gender: juser["gender"].string!, work: juser["work"].string!, school: juser["school"].string!, greetingMessage: greetingMessage)
            room.roomID = jroom["roomID"].int!
            room.messages = messages
            room.opponentUser = oppoentUser
            rooms.append(room)
        }
        
        return rooms
    }
    
    private class func getMessages(messages: [JSON]) -> [LGChatMessage]{
        var lgMessagesArray: [LGChatMessage] = []
        for messageDic in messages {
            let message = messageDic["message"].string!
            let isCurrent = messageDic["isCurrent"].bool!
            var sendBy: LGChatMessage.SentBy!
            if isCurrent {
                sendBy = .User
            } else {
                sendBy = .Opponent
            }
            let lgMessage = LGChatMessage(content: message, sentBy: sendBy)
            lgMessagesArray.append(lgMessage)
        }
        
        return lgMessagesArray
    }
    
    //========== API Request ===========
    
    internal class func createRoomWithAPI(sendUser: User, opponentUser: User, callback: (room: MessageRoom) -> Void) {
        let params = [
            "send_user_id": sendUser.fbID!,
            "opponent_user_id": opponentUser.fbID!
        ]
        
        Alamofire.request(.POST, "http://172.20.10.4:3000/api/v1/rooms/create", parameters: params, encoding: .JSON, headers: nil).responseJSON { (response) in
            guard let jValue = response.result.value else {
                print("room create api error: \(response.result.error)")
                return
            }
            
            let roomID = JSON(jValue)["roomID"].int!
            let lgMessagesArray = getMessages(JSON(jValue)["messages"].array!)
        
            guard let room = searchRoomWithID(roomID) else {
                let room = MessageRoom()
                room.roomID = roomID
                room.messages = lgMessagesArray
                callback(room: room)
                return
            }
            
            callback(room: room)
        }
    }
    
    internal class func createSenderMessageToRoomWithAPI(message: String, userID: String, roomID: Int, callback: (() -> Void)?) {
        let params = [
            "message": message,
            "user_id": userID,
            "room_id": roomID
        ]
        
        Alamofire.request(.POST, "http://172.20.10.4:3000/api/v1/messages/create", parameters: params as? [String : AnyObject], encoding: .JSON, headers: nil).responseJSON { (response) in
            callback?()
        }
    }
    
    internal class func getRoomsAndMessagesWithAPI(userFBID: String, callback: (() -> Void)?) {
        Alamofire.request(.GET, "http://172.20.10.4:3000/api/v1/rooms/index", parameters: nil, encoding: .JSON, headers: ["Fbid" : userFBID]).responseJSON { (response) in
            guard let value = response.result.value else {
                print("get room and message error: \(response.result.error)")
                return
            }
            let jValue = JSON(value)
            self.messageRooms = getRooms(jValue.array!)
            if let callback = callback {
                callback()
            }
        }
    }
}
