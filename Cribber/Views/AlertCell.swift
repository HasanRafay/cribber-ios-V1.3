//
//  AlertCell.swift
//  Cribber
//
//  Created by Tim Ross on 13/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

class AlertCell: FeedItemCell {
    override func setupView() {
        super.setupView()

        containerView.backgroundColor = Styles.darkYellowColor

        timeLabel.font = UIFont(name: Styles.latoRegularFontName, size: 14)!
        timeLabel.textColor = UIColor(hex: 0xF5DCB1)
        dateLabel.font = timeLabel.font
        dateLabel.textColor = timeLabel.textColor

        // Darker yellow bottom border:
        borderColor = UIColor(hex: 0xF1A114)

        messageLabel.textColor = UIColor.whiteColor()
    }
    
    override func updateFromFeedItem(feedItem: FeedItemInfo) {
        super.updateFromFeedItem(feedItem)
        
        // Capitalize alert text
        subjectLabel.text = subjectLabel.text?.uppercaseString
    }
}
