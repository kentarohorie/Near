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
    
    //=========== API request for AWS S3=============
    //===============================================
    
    class func uploadImageToS3(uploadFileURL: NSURL, image: UIImage, uploadImageName: String, isMain: Bool) {
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
                print("Error: \(error.localizedDescription)")
            }
            if let exception = task.exception {
                print("Exception: \(exception.description)")
            }
            if let _ = task.result {
                print("Upload Start")
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
            })
            if i == 4 {
                callback()
            }
        }
    }
    
    // edit doneを押したらしばらくお待ち下さい画面。その間にview情報の更新や、アップデート、s3アップロード。
    
    class func downloadImageFromS3(user: User, imageKeyPath: String, callback: (image: UIImage?) -> Void) {
        let S3BucketName: String = "nearfornearinc"
        let S3DownloadKeyName: String = "users/\(user.fbID!)/images/\(imageKeyPath)"
        
        let expression = AWSS3TransferUtilityDownloadExpression()
        let completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock = { (task, location, data, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                if ((error) != nil){
                    NSLog("Failed with error")
                    NSLog("Error: %@",error!);
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
                    NSLog("Error: %@",error.localizedDescription)
                }
                if let exception = task.exception {
                    NSLog("Exception: %@",exception.description);
                }
                if let _ = task.result {
                    NSLog("Download Starting!")
                }
                return nil;
        }
    }
    
}

