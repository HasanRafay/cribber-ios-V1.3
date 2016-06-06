//
//  FeedItemCell.swift
//  Cribber
//
//  Created by Tim Ross on 2/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import TTTAttributedLabel
import MessageUI



class FeedItemCell: UITableViewCell, TTTAttributedLabelDelegate, MFMailComposeViewControllerDelegate {
    let subjectLabel = UILabel()
    let fromLabel = UILabel()
    let messageLabel = TTTAttributedLabel(frame: CGRectZero)
    let timeLabel = UILabel()
    let dateLabel = UILabel()
    let logoImageView = UIImageView()
    let containerView = UIView()
    let borderView = UIView()
    var collectionView: UICollectionView!
    
    let dateFormatter = NSDateFormatter()
    let timeFormatter = NSDateFormatter()
    
    var shouldDisplayAttachments = false

    var borderColor : UIColor = Styles.grayColor {
        didSet {
            borderView.backgroundColor = borderColor
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    func updateFromFeedItem(feedItem: FeedItemInfo) {
        subjectLabel.text = feedItem.subject
        fromLabel.text = feedItem.from
        messageLabel.text = feedItem.message
        
        //now added hyperlink in the message body if its dummy feed item
        //these code added later
        if(feedItem is NoStationFeedItem)
        {
            //adding link in  meesage of dummy feed item
            
            let range = NSRange(location: 118, length: 28)
            messageLabel.addLinkToURL(NSURL(string: "RequestToInvite" ), withRange: range)
            
            //another link
            let range2 = NSRange(location: 192, length: 26)
            messageLabel.addLinkToURL(NSURL(string: "https://app.cribber.com/admin/sign_up" ), withRange: range2)
        }
        
        //end adding

        
        

        let localPublishDate = feedItem.publishDate.toLocalTime()
        timeLabel.text = timeFormatter.stringFromDate(localPublishDate)
        dateLabel.text = dateFormatter.stringFromDate(localPublishDate, sinceDate: NSDate().toLocalTime())
        if feedItem.logoURL != nil {
            let imageURL = NSURL(string: feedItem.logoURL!)
            logoImageView.sd_setImageWithURL(imageURL, placeholderImage: nil)
        } else {
            logoImageView.image = UIImage(named: "example-logo")
        }
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate delegate: protocol<UICollectionViewDelegate,UICollectionViewDataSource>, indexPath: NSIndexPath) {
        collectionView.dataSource = delegate
        collectionView.delegate = delegate
        collectionView.tag = indexPath.row
        
        collectionView.reloadData()
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }

    func removeCollectionViewDataSourceDelegate() {
        collectionView.dataSource = nil
        collectionView.delegate = nil
    }
    
    func setupView() {
        timeFormatter.AMSymbol = "am"
        timeFormatter.PMSymbol = "pm"
        timeFormatter.dateFormat = "h:mm a"
        dateFormatter.dateFormat = "dd-MMM-yy"
        
        contentView.layoutMargins = UIEdgeInsetsZero
        
        // Container View
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.layoutMargins = UIEdgeInsetsMake(10, 10, 13, 10)
        contentView.addSubview(containerView)

        containerView.snp_makeConstraints { make in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.contentView.snp_topMargin)
            make.left.greaterThanOrEqualTo(self.contentView.snp_leftMargin)
            make.bottom.equalTo(self.contentView.snp_bottomMargin)
            make.right.lessThanOrEqualTo(self.contentView.snp_rightMargin)
            make.width.equalTo(568).priorityHigh()
            make.height.greaterThanOrEqualTo(44)
            return
        }

        borderView.backgroundColor = borderColor
        containerView.addSubview(borderView)
        borderView.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalTo(containerView.snp_left)
            make.right.equalTo(containerView.snp_right)
            make.bottom.equalTo(containerView.snp_bottom)
        }

        // Logo Image View
        logoImageView.image = UIImage()
        logoImageView.contentMode = .ScaleAspectFit
        logoImageView.layer.cornerRadius = 2
        logoImageView.layer.masksToBounds = true
        containerView.addSubview(logoImageView)
        
        logoImageView.snp_makeConstraints { make in
            make.top.equalTo(self.containerView.snp_topMargin)
            make.left.equalTo(self.containerView.snp_leftMargin)
            make.width.equalTo(46)
            make.height.equalTo(46)
            return
        }

        // Time Label
        timeLabel.font = UIFont(name: Styles.latoLightFontName, size: 14)!
        timeLabel.textColor = Styles.darkGrayColor
        timeLabel.textAlignment = .Right
        containerView.addSubview(timeLabel)

        timeLabel.snp_makeConstraints { make in
            make.right.equalTo(self.containerView.snp_rightMargin)
            return
        }
        
        // Subject Label
        subjectLabel.font = UIFont(name: Styles.latoBoldFontName, size: 17)!
        subjectLabel.textColor = Styles.darkBlueColor
        containerView.addSubview(subjectLabel)
        
        subjectLabel.snp_makeConstraints { make in
            make.bottom.equalTo(self.logoImageView.snp_centerY).offset(1)
            make.left.equalTo(self.logoImageView.snp_right).offset(8)
            make.right.equalTo(self.timeLabel.snp_leftMargin)
            return
        }

        timeLabel.snp_updateConstraints { make in
            make.baseline.equalTo(self.subjectLabel.snp_baseline)
            return
        }
        
        // From Label
        fromLabel.font = UIFont(name: Styles.latoRegularFontName, size: 14)!
        fromLabel.textColor = Styles.brightRedColor
        containerView.addSubview(fromLabel)
        
        fromLabel.snp_makeConstraints { make in
            make.top.equalTo(self.subjectLabel.snp_bottom)
            make.left.equalTo(self.subjectLabel.snp_left)
            make.width.equalTo(self.subjectLabel.snp_width)
            return
        }
        
        // Date Label
        dateLabel.font = timeLabel.font
        dateLabel.textColor = timeLabel.textColor
        dateLabel.textAlignment = .Right
        containerView.addSubview(dateLabel)
        
        dateLabel.snp_makeConstraints { make in
            make.baseline.equalTo(self.fromLabel.snp_baseline)
            make.right.equalTo(self.containerView.snp_rightMargin)
            make.width.equalTo(self.timeLabel.snp_width)
            return
        }
        
        // Collection View
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0)
        layout.scrollDirection = .Horizontal
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.scrollsToTop = false
        collectionView.collectionViewLayout = layout
        collectionView.registerClass(AttachmentCell.self, forCellWithReuseIdentifier: "AttachmentCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clearColor()
        containerView.addSubview(collectionView)
        
        collectionView.snp_makeConstraints { make in
            make.left.equalTo(self.subjectLabel.snp_left)
            make.bottom.equalTo(self.containerView.snp_bottomMargin)
            make.right.equalTo(self.containerView.snp_rightMargin)
            make.height.equalTo(120).priorityLow()
            return
        }
        
        // Message Label
        messageLabel.delegate = self
        messageLabel.font = UIFont(name: Styles.latoRegularFontName, size: 17)!
        messageLabel.textColor = Styles.darkestGrayColor
        messageLabel.linkAttributes = [
            kCTForegroundColorAttributeName: Styles.brightRedColor
        ]
        messageLabel.activeLinkAttributes = [
            kCTForegroundColorAttributeName: Styles.lightRedColor
        ]
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .ByWordWrapping
        messageLabel.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        containerView.addSubview(messageLabel)

        messageLabel.snp_makeConstraints { make in
            make.top.equalTo(self.fromLabel.snp_bottom).offset(8)
            make.left.equalTo(self.subjectLabel.snp_left)
            make.bottom.equalTo(self.collectionView.snp_top)
            make.right.equalTo(self.containerView.snp_rightMargin)
            return
        }
    }
    
    override func updateConstraints() {
        let collectionViewHeight = shouldDisplayAttachments ? (Constants.AttachmentItemHeight + 8) : 0
        
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.snp_updateConstraints { make in
            make.height.equalTo(collectionViewHeight).priorityHigh()
            return
        }
    
        super.updateConstraints()
    }

    // MARK: - TTTAttributedLabelDelegate methods

    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        
        if(url.absoluteString == "RequestToInvite")
        {
            let mailComposeViewController = configureRequestMail()
            if MFMailComposeViewController.canSendMail()
            {
                self.window?.rootViewController?.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else
            {
                self.showSendMailErrorAlert()
            }
        }
        else
        {
            url.openInSafari()
        }

    }
    
    
    func configureRequestMail() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        print(AuthenticationManager.sharedInstance.phoneNumber!)
        
//        let messageBody = "<p>I've downloaded and installed the Cribber app on my mobile device. Can you please invite me to our Cribber team using my mobile number \(AuthenticationManager.sharedInstance.phoneNumber!)?</p> <p>If we don't have an account we can sign up for free here.</p> --<br> Cribber gives teams their very own mobile newsfeed for workplace bulletins and alerts. Meaning everyone is informed and up to date. Find out more at www.cribber.com."
//        
        
        let messageBody = "<p>I've downloaded and installed the Cribber app on my mobile device. Can you please invite me to our Cribber team using my mobile number \(AuthenticationManager.sharedInstance.phoneNumber!)?</p> <p>If we don't have an account we can sign up for free <a href=\"https://app.cribber.com/admin/sign_up\" style=\"text-decoration:none\">here</a>.</p> --<br> Cribber gives teams their very own mobile newsfeed for workplace bulletins and alerts. Meaning everyone is informed and up to date. Find out more at www.cribber.com."
        

        
        
        
        mailComposerVC.setSubject("Cribber Communication Invite")    
        
        mailComposerVC.setMessageBody(messageBody, isHTML: true)
        
        //mailComposerVC.setMessageBody("I've downloaded and installed the Cribber app on my mobile device. Can you please invite me to our Cribber team using my mobile number \(AuthenticationManager.sharedInstance.phoneNumber!)? If we don't have an account we can sign up for free here. -- Cribber gives teams their very own mobile newsfeed for workplace bulletins and alerts. Meaning everyone is informed and up to date. Find out more at www.cribber.com.", isHTML: true)

        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

}
