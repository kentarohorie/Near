//
//  ProfileView.swift
//  Near
//
//  Created by 堀江健太朗 on 2016/05/01.
//  Copyright © 2016年 kentaro. All rights reserved.
//

import UIKit

@objc protocol ProfileViewDelegate {
    func profileView(tapEdit sender: UIView)
}

class ProfileView: UIView, ProfileViewModelDelegate {

    private var boardScrollView: UIScrollView!
    private var baseHeadScrollViewHeight: CGFloat!
    private var nameAgeLabelFontSize: CGFloat!
    private var etcInfoLabelFontSize: CGFloat!
    private var textCoverView: UIView = UIView()
    private var textLabelArray: [UILabel] = []
    private var user: User?
    
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
    
    private func setUP() {
        // view base point
        baseHeadScrollViewHeight = self.frame.height / 5 * 3
        nameAgeLabelFontSize = 21
        etcInfoLabelFontSize = 10
        
        // set view. right order
        setBoardScrollView()
        setHeadImageScrollView(user!.avatar!)
        textCoverView.frame.origin = CGPoint(x: 0, y: baseHeadScrollViewHeight)
        boardScrollView.addSubview(textCoverView)
        setNameAgeLabel((user?.userName)!, age: String(user!.age!))
        setActionButton()
        setAllETCLabel(["フリーランス", "関西大学卒業", "ログイン １時間前"])
        setTextCoverViewFrame()
        setTextView("楽しいことが大好き〜！\n\n好きな物は映画鑑賞とか読書とか〜！\n楽しい方とお話し出来たら嬉しいです！")
        
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
    
    private func setHeadImageScrollView(image: UIImage) {
        let scrollView = UIScrollView()
        scrollView.frame.size = CGSize(width: self.frame.width, height: baseHeadScrollViewHeight)
        scrollView.frame.origin = CGPoint(x: 0, y: 0)
        boardScrollView.addSubview(scrollView)
        
        let imageView = UIImageView(image: image)
        imageView.frame = scrollView.frame
        imageView.contentMode = .ScaleAspectFill
        scrollView.addSubview(imageView)
        
        //============== 複数カバーイメージを設定するときに ============
        //        let imageViewB = UIImageView(image: UIImage(named: "cat.jpg"))
        //        imageViewB.frame.size = headerScrollView.frame.size
        //        headerScrollView.contentSize = CGSize(width: self.frame.width * 2, height: headerScrollView.frame.height)
        //        imageViewB.frame.origin = CGPoint(x: self.frame.width, y: headerScrollView.frame.origin.y)
        //        headerScrollView.addSubview(imageViewB)
        //        headerScrollView.pagingEnabled = true
        //========================================================
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
        label.frame.origin = CGPoint(x: 16, y: yPoint - 4)
        textCoverView.addSubview(label)
        textLabelArray.append(label)
    }
    
    private func setAllETCLabel(textArray: [String]) {
        for (i, text) in textArray.enumerate() {
            setETCLabel(text, topLabel: textLabelArray[i])
        }
    }
    
    private func setTextCoverViewFrame() {
        let textCoverViewHeight = textLabelArray.last!.frame.height + textLabelArray.last!.frame.origin.y
        textCoverView.frame.size = CGSize(width: self.frame.width, height: textCoverViewHeight)
    }
    
    private func setTextView(text: String) {
        let baseY = textCoverView.frame.height + textCoverView.frame.origin.y + 16
        
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
            imageName = "message_prof"
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
    
    func tapActionButton() {
        if isCurrentUser {
            delegate?.profileView(tapEdit: self)
        } else {
            print("go message")
        }
    }

}
