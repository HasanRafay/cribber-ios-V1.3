//
//  LocalCell.swift
//  Cribber
//
//  Created by Tim Ross on 4/05/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

class LocalCell: FeedItemCell {
    override func updateFromFeedItem(feedItem: FeedItemInfo) {
        super.updateFromFeedItem(feedItem)
        
        logoImageView.image = UIImage(named: "cribber-logo-small")
    }
}
