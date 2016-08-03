
//
//  ProfileView.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit
import MessageUI

@objc protocol ProfileViewDelegate {
    func profileView(tapEdit sender: UIView)
    func profileView(willSegueToMessage sender: UIView, room: MessageRoom, opponentUser: User)
}

class ProfileView: UIView, ProfileViewModelDelegate, UIScrollViewDelegate, MFMailComposeViewControllerDelegate {

    private var boardScrollView: UIScrollView!
    private var baseHeadScrollViewHeight: CGFloat!
    private var nameAgeLabelFontSize: CGFloat!
    private var etcInfoLabelFontSize: CGFloat!
    private var textCoverView: UIView = UIView()
    private var textLabelArray: [UILabel] = []
    private var user: User?
    private var pageControl: UIPageControl!
    
    internal var isCurrentUser = false
    internal var delegate: ProfileViewDelegate?
    
    init(frame: CGRect, isCurrentUser: Bool) {
        super.init(frame: frame)
        self.isCurrentUser = isCurrentUser
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setUser(user: User) {
        self.user = user
        setUP()
    }
    
    internal func reload() {
//        boardScrollView = nil
//        boardScrollView.removeFromSuperview() 編集結果がうまく反映されない。

//        // set view. right order
//        setBoardScrollView()
//        setHeadImageScrollView()
//        textCoverView.frame.origin = CGPoint(x: 0, y: baseHeadScrollViewHeight)
//        boardScrollView.addSubview(textCoverView)
//        setNameAgeLabel((user?.userName)!, age: String(user!.age!))
//        
//        if User.currentUser == user {
//            setAllETCLabel([(user?.work)!, (user?.school)!])
//        } else {
//            setAllETCLabel([(user?.work)!, (user?.school)!, (user?.loginTime)!])
//        }
//        setTextCoverViewFrame()
//        setTextView((user?.greetingMessage)!)
//        setActionButton()
//        
//        // setting
//        boardScrollView.showsVerticalScrollIndicator = false
    }
    
    private func setUP() {
        // view base point
        baseHeadScrollViewHeight = self.frame.height / 5 * 3
        nameAgeLabelFontSize = 21
        etcInfoLabelFontSize = 10
        
        // set view. right order
        setBoardScrollView()
        setHeadImageScrollView()
        textCoverView.frame.origin = CGPoint(x: 0, y: baseHeadScrollViewHeight)
        boardScrollView.addSubview(textCoverView)
        setNameAgeLabel((user?.userName)!, age: String(user!.age!))
        setActionButton()
        
        if User.currentUser == user {
            setAllETCLabel([(user?.work)!, (user?.school)!])
        } else {
            setAllETCLabel([(user?.work)!, (user?.school)!, (user?.loginTime)!])
        }
        setTextCoverViewFrame()
        setTextView((user?.greetingMessage)!)
        
        // setting
        boardScrollView.showsVerticalScrollIndicator = false
    }
    
    //================== set views ==================
    
    private func setBoardScrollView() {
        boardScrollView = UIScrollView()
        boardScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        boardScrollView.backgroundColor = UIColor.whiteColor()
        self.addSubview(boardScrollView)
    }
    
    private func setHeadImageScrollView() {
        let scrollView = UIScrollView()
        scrollView.frame.size = CGSize(width: self.frame.width, height: baseHeadScrollViewHeight)
        scrollView.frame.origin = CGPoint(x: 0, y: 0)
        scrollView.delegate = self
        boardScrollView.addSubview(scrollView)
        
        let imageView = UIImageView(image: user?.avatar!)
        imageView.frame.size = CGSize(width: self.frame.width, height: baseHeadScrollViewHeight)
        imageView.frame.origin = CGPoint(x: 0, y: 0)
        imageView.contentMode = .ScaleAspectFill
        scrollView.addSubview(imageView)
        
        let subImages = getUnwrappedSubImage(user!.subImages)
        for (i, image) in subImages.enumerate() {
            let subImageView = UIImageView(image: image)
            subImageView.frame.size = CGSize(width: self.frame.width, height: baseHeadScrollViewHeight)
            subImageView.frame.origin = CGPoint(x: self.frame.width * CGFloat(i + 1), y: 0)
            subImageView.contentMode = .ScaleAspectFill
            scrollView.addSubview(subImageView)
        }
        
        scrollView.contentSize = CGSize(width: self.frame.width * CGFloat(subImages.count + 1), height: baseHeadScrollViewHeight)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        setPageControl(subImages.count)
    }
    
    private func setPageControl(numOfPage: Int) {
        pageControl = UIPageControl()
        pageControl.frame.size = CGSize(width: self.frame.width / 2, height: 50)
        pageControl.center = CGPoint(x: self.frame.width / 2, y: baseHeadScrollViewHeight - 16)
        pageControl.numberOfPages = numOfPage + 1
        pageControl.currentPage = 0
        pageControl.userInteractionEnabled = true
        boardScrollView.addSubview(pageControl)
    }
    
    private func getUnwrappedSubImage(images: [UIImage?]) -> [UIImage] {
        var subImages: [UIImage] = []
        for image in images {
            guard let uImage = image else {
                continue
            }
            
            subImages.append(uImage)
        }
        
        return subImages
    }
    
    private func setNameAgeLabel(name: String, age: String) {
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: nameAgeLabelFontSize)
        nameLabel.sizeToFit()
        nameLabel.frame.origin = CGPoint(x: 16, y: 8)
        
        let ageLabel = UILabel()
        let ageLabelX = nameLabel.frame.width + nameLabel.frame.origin.x + 4
        ageLabel.text = age + "歳"
        ageLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: nameAgeLabelFontSize)
        ageLabel.sizeToFit()
        ageLabel.frame.origin = CGPoint(x: ageLabelX, y: 8)
        
        textCoverView.addSubview(nameLabel)
        textCoverView.addSubview(ageLabel)
        textLabelArray.append(nameLabel)
    }
    
    private func setETCLabel(text: String, topLabel: UILabel) {
        let label = UILabel()
        label.text = text
        label.sizeToFit()
        label.font = UIFont(name: "AppleSDGothicNeo-Light", size: etcInfoLabelFontSize)
        let yPoint = topLabel.frame.origin.y + topLabel.frame.height
        label.frame.origin = CGPoint(x: 16, y: yPoint)
        textCoverView.addSubview(label)
        textLabelArray.append(label)
    }
    
    private func setAllETCLabel(textArray: [String]) {
        for (i, text) in textArray.enumerate() {
            setETCLabel(text, topLabel: textLabelArray[i])
        }
    }
    
    private func setTextCoverViewFrame() {
        let textCoverViewHeight = textLabelArray.last!.frame.height + textLabelArray.last!.frame.origin.y + 20
        textCoverView.frame.size = CGSize(width: self.frame.width, height: textCoverViewHeight)
    }
    
    private func setTextView(text: String) {
        let baseY = textCoverView.frame.height + textCoverView.frame.origin.y + 32
        
        let titleLabel = UILabel()
        titleLabel.text = "About me"
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: etcInfoLabelFontSize + 3)
        titleLabel.sizeToFit()
        titleLabel.frame.origin = CGPoint(x: 16, y: baseY)
        
        let textView = UITextView()
        textView.text = text
        textView.font = UIFont(name: "AppleSDGothicNeo-Light", size: etcInfoLabelFontSize + 3)
        textView.sizeToFit()
        textView.frame.origin = CGPoint(x: 11, y: baseY + titleLabel.frame.height)
        textView.scrollEnabled = false
        
        boardScrollView.addSubview(titleLabel)
        boardScrollView.addSubview(textView)
        setBoardScrollViewContentSize(textView)
    }
    
    private func setBoardScrollViewContentSize(baseView: UIView) {
        boardScrollView.contentSize = CGSize(width: self.frame.width, height: baseView.frame.height + baseView.frame.origin.y + 100)
    }
    
    private func setActionButton() {
        var imageName = ""
        
        if isCurrentUser {
            imageName = "system"
        } else {
            imageName = "more_info"
        }
        let imageView = UIImageView(image: UIImage(named: imageName)!.imageWithRenderingMode(.AlwaysTemplate))
        let gestureRecog = UITapGestureRecognizer(target: self, action: #selector(ProfileView.tapActionButton))
        imageView.tintColor = UIColor.customOrange()
        imageView.frame.size = CGSize(width: 64, height: 64)
        imageView.frame.origin = CGPoint(x: self.frame.width - 72, y: 8)
        imageView.addGestureRecognizer(gestureRecog)
        imageView.userInteractionEnabled = true
        textCoverView.addSubview(imageView)
    }
    
    private func setCurrentUserActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let editAtion = UIAlertAction(title: "プロフィール編集", style: .Default) { (alert) in
            self.delegate?.profileView(tapEdit: self)
        }
        let reportAction = UIAlertAction(title: "報告/ご要望", style: .Default) { (alert) in
            self.setUPMailer("Nearをご利用いただきありがとうございます。\nNearへのご要望や意見など、どんなことでもお送りください。\n\n今後ともNearをよろしくお願いいたします。")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        actionSheet.addAction(editAtion)
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)
        
        self.getSuperViewController().presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    private func setNotCurrentUserActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let messageAction = UIAlertAction(title: "メッセージ", style: .Default) { (alert) in
            MessageRoomManager.createRoomWithAPI(User.currentUser, opponentUser: self.user!, callback: { (room) in
                self.delegate?.profileView(willSegueToMessage: self, room: room, opponentUser: self.user!)
            })
        }
        let blockAction = UIAlertAction(title: "ブロック", style: .Default) { (alert) in
            self.setUPMailer("このまま送信してください。\n\(self.user!.fbID!)")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        actionSheet.addAction(messageAction)
        actionSheet.addAction(blockAction)
        actionSheet.addAction(cancelAction)
        
        self.getSuperViewController().presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    private func setUPMailer(message: String) {
        let mailViewController = MFMailComposeViewController()
        let toRecipient = ["info.ratneko@gmail.com"]
        
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject("[Near]")
        mailViewController.setToRecipients(toRecipient)
        mailViewController.setMessageBody(message, isHTML: false)
        
        self.getSuperViewController().presentViewController(mailViewController, animated: true, completion: nil)
    }
    
    //======= action & delegate =============
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tapActionButton() {
        if isCurrentUser {
            setCurrentUserActionSheet()
        } else {
            setNotCurrentUserActionSheet()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        }
    }

}
