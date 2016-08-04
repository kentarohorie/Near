//
//  User.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/22.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AWSS3

class User: NSObject {
    static var currentUser: User = User()
    static var coordinate: [String] = []
    static var timeLineUsers: [User] = []
    
    var userName: String?
    var gender: String?
    var age: Int?
    var facebookETCImage: [UIImage]?
    var greetingMessage: String?
    var work: String?
    var school: String?
    var loginTime: String?
    var fbID: String?
    var distanceFromCurrentUser: Int?
    
    var avatar: UIImage?
    var subImages: [UIImage?] = [nil, nil, nil, nil, nil]
    
    class func setCurrentUser(name: String, age: Int, fbID: String, gender: String, work: String, school: String, greetingMessage: String) {
        self.currentUser = getUser(name, age: age, fbID: fbID, gender: gender, work: work, school: school, greetingMessage: greetingMessage)
        setNowLoginTime()
    }
    
    class func getUser(name: String, age: Int, fbID: String, gender: String, work: String, school: String, greetingMessage: String) -> User {
        let user = User()
        var profileImage: UIImage!
        let URL = NSURL(string: "https://graph.facebook.com/\(fbID)/picture?type=large")
        profileImage = UIImage(named: "empty_user")
        
        if let avatarImage = UIImage(data: NSData(contentsOfURL: URL!)!) {
            profileImage = avatarImage
        }
        
        user.avatar = profileImage
        user.userName = name
        user.age = age
        user.gender = gender
        user.fbID = fbID
        user.greetingMessage = greetingMessage
        user.work = work
        user.school = school
        
        return user
    }
    
    class func setNowLoginTime() {
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .MediumStyle
        dateFormatter.dateStyle = .MediumStyle
        currentUser.loginTime = dateFormatter.stringFromDate(now)
    }
    
    private class func setTimelineUsersFromJSON(users: [JSON]) {
        for jUser in users {
            var user = User()
            let name = jUser["name"].string!
            let age = jUser["age"].int!
            let fbID = jUser["fbID"].string!
            let gender = jUser["gender"].string!
            let work = jUser["work"].string!
            let school = jUser["school"].string!
            var greetingMessage = ""
            if jUser["greetingMessage"] != nil {
                greetingMessage = jUser["greetingMessage"].string!
            }
            user = getUser(name, age: age, fbID: fbID, gender: gender, work: work, school: school, greetingMessage: greetingMessage)
            
            let nsDate = NSDate()
            let date = jUser["loginTime"].string!
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let dateData = dateFormatter.dateFromString(date)
            user.loginTime = nsDate.offsetFrom(dateData!)
            user.distanceFromCurrentUser = jUser["distance"].int!
            timeLineUsers.append(user)
        }
    }
    
    //============= API request =====================
    //===============================================
    
    class func createUserWithAPI(fbID: String, gender: String, age: Int, name: String, callback: () -> Void) {
        setNowLoginTime()
        let params = [
            "facebook_id": fbID,
            "gender": gender,
            "age": age,
            "name": name,
            "latitude": User.coordinate[0],
            "longitude": User.coordinate[1],
            "login_time": User.currentUser.loginTime!
        ]
        Alamofire.request(.POST, "https://young-thicket-95274.herokuapp.com/api/v1/users/create", parameters: params as? [String: AnyObject], encoding: .JSON).responseJSON { (response) in
            guard response.result.error == nil else {
                print("create user request error: \(response.result.error)")
                return
            }
            let jValue = JSON(response.result.value!)
            let userID = jValue["userID"].int!
            let ud = NSUserDefaults.standardUserDefaults()
            ud.setObject(userID, forKey: "userID")
            callback()
        }
    }
    
    class func fetchFromAPI(callback: () -> Void) {
        let ud = NSUserDefaults.standardUserDefaults()
        let userID = ud.objectForKey("userID")
        
        Alamofire.request(.GET, "https://young-thicket-95274.herokuapp.com/api/v1/users/\(userID!)").responseJSON { (response) in
            guard response.result.error == nil, let value = response.result.value else {
                print("fetch from API request error: \(response.result.error)")
                return
            }
            let jValue = JSON(value)
            var greetingMessage = ""
            if jValue["greetingMessage"] != nil {
                greetingMessage = jValue["greetingMessage"].string!
            }
            setCurrentUser(jValue["name"].string!, age: jValue["age"].int!, fbID: jValue["fbID"].string!, gender: jValue["gender"].string!, work: jValue["work"].string!, school: jValue["school"].string!, greetingMessage: greetingMessage)
            callback()
        }
    }
    
    class func updateUserWithAPI(age: Int, name: String, latitude: String, longitude: String, loginTime: String, school: String?, work: String?, greetingMessage: String?, callback: () -> Void) {
        let ud = NSUserDefaults.standardUserDefaults()
        let userID = ud.objectForKey("userID")
        
        var pwork = "", pschool = "", pgreetingMessage = ""
        if currentUser.work != nil {
            pwork = currentUser.work!
        }
        
        if currentUser.school != nil {
            pschool = currentUser.school!
        }
        
        if currentUser.greetingMessage != nil {
            pgreetingMessage = currentUser.greetingMessage!
        }
        
        
        let params = [
            "age": age,
            "name": name,
            "latitude": latitude,
            "longitude": longitude,
            "login_time": loginTime,
            "school": pschool,
            "work": pwork,
            "greeting": pgreetingMessage
        ]
        
        Alamofire.request(.PUT, "https://young-thicket-95274.herokuapp.com/api/v1/users/\(userID!)", parameters: params as? [String: AnyObject], encoding: .JSON).responseJSON { (response) in
            guard response.result.error == nil else {
                print("update API error: \(response.result.error)")
                return
            }
            
            callback()
        }
    }
    
    class func getUsersForTimelineAPI(callback: () -> Void) {
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: "https://young-thicket-95274.herokuapp.com/api/v1/users/")!)
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
    
    class func blockUser(blockedUserFBID: String) {
        for (i, user) in timeLineUsers.enumerate() {
            if user.fbID! == blockedUserFBID {
                timeLineUsers.removeAtIndex(i)
            }
        }
        
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: "https://young-thicket-95274.herokuapp.com/api/v1/users/block/\(blockedUserFBID)")!)
        mutableURLRequest.HTTPMethod = "POST"
        mutableURLRequest.addValue(currentUser.fbID!, forHTTPHeaderField: "Fbid")
        Alamofire.Manager.sharedInstance.request(mutableURLRequest).responseJSON { (response) in
        }
    }
    
    //=========== API request for AWS S3=============
    //===============================================
    
    class func uploadImageToS3(uploadFileURL: NSURL, image: UIImage, uploadImageName: String, isMain: Bool, callback: () -> Void) {
        let uploadFileURL = uploadFileURL
        let imageName = uploadFileURL.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
        
        // getting local path
        let localPath = (documentDirectory as NSString).stringByAppendingPathComponent(imageName!)
        
        //getting actual image
        let image = image
        let data = UIImagePNGRepresentation(image)
        data!.writeToFile(localPath, atomically: true)
        
        let imageURL = NSURL(fileURLWithPath: localPath)
        
        let S3BucketName = "nearfornearinc"
        var S3UploadKeyName = ""
        if isMain {
            S3UploadKeyName = "users/\(currentUser.fbID!)/images/main.png"
        } else {
            S3UploadKeyName = "users/\(currentUser.fbID!)/images/subs/\(uploadImageName).png"
        }
        
        let transferUtility = AWSS3TransferUtility.defaultS3TransferUtility()
        let expression = AWSS3TransferUtilityUploadExpression()
        
        transferUtility.uploadFile(imageURL, bucket: S3BucketName, key: S3UploadKeyName, contentType: "image/png", expression: expression, completionHander: nil).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                print("*S3 UPLOAD ERROR*: \(error.localizedDescription)")
            }
            if let exception = task.exception {
                print("*S3 UPDATE EXCEPTION*: \(exception.description)")
            }
            if let _ = task.result {
                print("*S3 UPDATE START*")
                callback()
            }
            return nil;
        }
    }
    
    class func downLoadAllImageFromS3(user: User, callback: () -> Void) {
        downloadImageFromS3(currentUser, imageKeyPath: "main.png", callback: { (image) in
            if let img = image {
                user.avatar = img
            }
        })
        for (i, _) in user.subImages.enumerate() {
            downloadImageFromS3(user, imageKeyPath: "subs/\(i).png", callback: { (image) in
                if let img = image {
                    user.subImages[i] = img
                }
                
                if i == 4 {
                    callback()
                }
            })
        }
    }
    
    class func downloadImageFromS3(user: User, imageKeyPath: String, callback: (image: UIImage?) -> Void) {
        let S3BucketName: String = "nearfornearinc"
        let S3DownloadKeyName: String = "users/\(user.fbID!)/images/\(imageKeyPath)"
        
        let expression = AWSS3TransferUtilityDownloadExpression()
        let completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock = { (task, location, data, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if ((error) != nil){
                    NSLog("*S3 COMPLETION DOWNLOAD ERROR*: %@",error!);
                    callback(image: nil)
                }
                else {
                    callback(image: UIImage(data: data!))
                }
            })
        }
        
        let transferUtility = AWSS3TransferUtility.defaultS3TransferUtility()
        
        transferUtility.downloadDataFromBucket(
            S3BucketName,
            key: S3DownloadKeyName,
            expression: expression,
            completionHander: completionHandler).continueWithBlock { (task) -> AnyObject? in
                if let error = task.error {
                    NSLog("*S3 DOWNLOAD ERROR*: %@",error.localizedDescription)
                }
                if let exception = task.exception {
                    NSLog("*S3 DOWNLOAD EXCEPTION*: %@",exception.description);
                }
                if let _ = task.result {
                    NSLog("*DOWNLOAD START*")
                }
                return nil;
        }
    }
    
}

