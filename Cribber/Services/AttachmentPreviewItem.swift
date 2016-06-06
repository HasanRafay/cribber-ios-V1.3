//
//  AttachmentPreviewItem.swift
//  Cribber
//
//  Created by Tim Ross on 10/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

class AttachmentPreviewItem: NSObject {
    var URL: NSURL?
    let title: String
    
    init(attachment: Attachment) {
        if let localFilePath = attachment.localFilePath {
            URL = NSURL(fileURLWithPath: localFilePath)
        }
        title = attachment.title
    }
}
