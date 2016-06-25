//
//  User.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/22.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire //dataが無い場合に代替データを突っ込んでエラーを回避しよう。

class User: NSObject {
    static var currentUser: User = User()
    static var coordinate: [String] = []
    static var timeLineUsers: [User] = []
    
    var userName: String?
    var gender: String?
    var age: Int?
    var avatar: UIImage?
    var profileCoverImage: UIImage?
    var facebookETCImage: [UIImage]?
    var greetingMessage: String?
    var company: String?
    var university: String?
    var address: String?
    var relationship: String?
    var location: String?
    var loginTime: String? //current => 0000/00/00 ...., others => 00分前
    var fbID: String?
    var distanceFromCurrentUser: Int?
    
    class func sampleSetUP() -> [User] {
        let sampleNames = ["Milly", "Emi", "May", "Anna", "Jenne", "Ema"]
        let age = [21, 30, 28, 25, 19, 23]
        let avatar = setAvatarImage()
        let profileCoverImages = setAvatarImage()
        let facebookImage: [UIImage] = [UIImage(named: "profile_sample_2")!, UIImage(named: "profile_sample_3")!, UIImage(named: "profile_sample_4")!]
        let greetingMessage = ["友達が欲しい", "海外行きたい!", "１人の夜は寂しい。。。", "飲みに行きたいなぁ", "", "ジム通い中"]
        let company = ["NRI", "Google", "", "", "softbank", "Recruit"]
        let university = ["明治大学", "東京大学", "早稲田大学", "慶応義塾大学", "京都大学", "早稲田大学"]
        let address = ["世田谷区", "新宿区", "渋谷区", "渋谷区", "新宿区", "渋谷区"]
        let relationship = ["Kana Nishino", "", "Aruki Hotta", "", "", "福山雅治"]
        let location = ["200m", "500mm", "1.6km", "2km", "2.2km", "3km"]//["世田谷", "渋谷区", "渋谷区", "新宿", "銀座", "渋谷区"]
        let loginTime = [15, 40, 1, 1, 2, 4]
        
        var users: [User] = []
        for i in 0...5 {
            users.append(setUser(sampleNames[i], age: age[i], avatar: avatar[i], profileCoverImage: profileCoverImages[i], fbETCImage: facebookImage, greetingMessage: greetingMessage[i], company: company[i], university: university[i], address: address[i], relationship: relationship[i], location: location[i], loginTime: loginTime[i]))
        }
        
        return users
    }
    
    class func setCurrentUser(name: String, age: Int, fbID: String, gender: String) {
        var profileImage: UIImage!
        let URL = NSURL(string: "https://graph.facebook.com/\(fbID)/picture?type=large")
        
        guard let contentURL = URL else {
            profileImage = UIImage(named: "empty_user")
            return
        }
        profileImage = UIImage(data: NSData(contentsOfURL: contentURL)!)
        self.currentUser.avatar = profileImage
        self.currentUser.userName = name
        self.currentUser.age = age
        self.currentUser.gender = gender
        self.currentUser.fbID = fbID
    }
    
    class func setNowLoginTime() {
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .MediumStyle
        dateFormatter.dateStyle = .MediumStyle
        currentUser.loginTime = dateFormatter.stringFromDate(now)
    }
    
    private class func setUser(name: String?, age: Int?, avatar: UIImage?, profileCoverImage: UIImage?, fbETCImage: [UIImage]?  , greetingMessage: String?, company: String?, university: String?, address: String?, relationship: String?, location: String?, loginTime: Int?) -> User {
        let user = User()
        user.userName = name
        user.age = age
        user.avatar = avatar
        user.profileCoverImage = profileCoverImage
        user.facebookETCImage = fbETCImage
        user.greetingMessage = greetingMessage
        user.company = company
        user.university = university
        user.address = address
        user.relationship = relationship
        user.location = location
//        user.loginTime = loginTime
        return user
    }
    
    private class func setTimelineUsersFromJSON(users: [JSON]) {
        for jUser in users {
            var profileImage: UIImage!
            let URL = NSURL(string: "https://graph.facebook.com/\(jUser["fbID"].string!)/picture?type=large")
            
            guard let contentURL = URL else {
                profileImage = UIImage(named: "empty_user")
                return
            }
            profileImage = UIImage(data: NSData(contentsOfURL: contentURL)!)
            
            let user = User()
            let nsDate = NSDate()
            user.userName = jUser["name"].string!
            user.age = jUser["age"].int!
            user.gender = jUser["gender"].string!
            user.distanceFromCurrentUser = jUser["distance"].int!
            user.avatar = profileImage
            
            let date = jUser["loginTime"].string!
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let dateData = dateFormatter.dateFromString(date)
            user.loginTime = nsDate.offsetFrom(dateData!)
            timeLineUsers.append(user)
        }
    }
    
    private class func setAvatarImage() -> [UIImage]{
        var imgViews: [UIImage] = []
        let imgNames = ["sample_user", "user_sample_2", "user_sample_3", "sample_user_4", "sample_user_5", "user_sample_6"]
        for i in imgNames {
            imgViews.append(UIImage(named: i)!)
        }
        
        return imgViews
    }
    
    //============= API request =====================
    //===============================================
    
    class func createUserWithAPI(fbID: String, gender: String, age: Int, name: String, callback: () -> Void) {
        let params = [
            "facebook_id": fbID,
            "gender": gender,
            "age": age,
            "name": name,
            "latitude": User.coordinate[0],
            "longitude": User.coordinate[1],
            "login_time": User.currentUser.loginTime!
        ]
        Alamofire.request(.POST, "http://172.20.10.4:3000/api/v1/users/create", parameters: params as? [String: AnyObject], encoding: .JSON).responseJSON { (response) in
            guard response.result.error == nil else {
                print("create user request error: \(response.result.error)")
                return
            }
            let userID = response.result.value!["userID"]!
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(userID, forKey: "userID")
            callback()
        }
    }
    
    class func fetchFromAPI(callback: () -> Void) {
        let ud = NSUserDefaults.standardUserDefaults()
        let userID = ud.objectForKey("userID")
        
        Alamofire.request(.GET, "http://172.20.10.4:3000/api/v1/users/\(userID!)").responseJSON { (response) in
            guard response.result.error == nil, let value = response.result.value else {
                print("fetch from API request error: \(response.result.error)")
                return
            }
            let jValue = JSON(value)
            setCurrentUser(jValue["name"].string!, age: jValue["age"].int!, fbID: jValue["fbID"].string!, gender: jValue["gender"].string!)
            callback()
        }
    }
    
    class func updateUserWithAPI(age: Int, name: String, latitude: String, longitude: String, loginTime: String, callback: () -> Void) {
        let ud = NSUserDefaults.standardUserDefaults()
        let userID = ud.objectForKey("userID")
        
        let params = [
            "age": age,
            "name": name,
            "latitude": latitude,
            "longitude": longitude,
            "login_time": loginTime
        ]
        
        Alamofire.request(.PUT, "http://172.20.10.4:3000/api/v1/users/\(userID!)", parameters: params as? [String: AnyObject], encoding: .JSON).responseJSON { (response) in
            guard response.result.error == nil else {
                print("update API error: \(response.result.error)")
                return
            }
            
            callback()
        }
    }
    
    class func getUsersForTimelineAPI(callback: () -> Void) {
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: "http://172.20.10.4:3000/api/v1/users/")!)
        mutableURLRequest.HTTPMethod = "GET"
        mutableURLRequest.addValue(currentUser.fbID!, forHTTPHeaderField: "Fbid")
        let manager = Alamofire.Manager.sharedInstance
        manager.request(mutableURLRequest).responseJSON { (response) in
            guard response.result.error == nil, let value = response.result.value else {
                print("get timeline users error: \(response.result.error)")
                return
            }
            
            let jValue = JSON(value)
            setTimelineUsersFromJSON(jValue.array!)
            callback()
        }
    }
    
    class func uploadImageTest() {
        let imageData = UIImagePNGRepresentation(currentUser.avatar!)?.base64EncodedDataWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let params = [
            "image": currentUser.avatar!]
        
        Alamofire.request(.PUT, "http://172.20.10.4:3000/api/v1/users/3", parameters: params)
    }
    
}

