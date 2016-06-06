//
//  AttachmentExtensions.swift
//  Cribber
//
//  Created by Tim Ross on 17/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

extension Attachment: Identifiable {
    var attachmentType: AttachmentType? {
        return AttachmentType(rawValue: contentType)
    }
    
    func placeholderImage() -> UIImage {
        var imageName = "doc-unknown"
        if let attachmentType = self.attachmentType {
            switch attachmentType {
            case .PNGImage, .JPGImage, .GIFImage:
                imageName = "doc-image"
            case .PDFDocument:
                imageName = "doc-pdf"
            case .DOCDocument, .DOCXDocument:
                imageName = "doc-word"
            case .XLSDocument, .XLSXDocument:
                imageName = "doc-excel"
            }
        }
        return UIImage(named: imageName)!
    }
}
