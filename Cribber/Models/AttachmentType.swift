//
//  AttachmentType.swift
//  Cribber
//
//  Created by Tim Ross on 16/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation

enum AttachmentType: String {
    case PDFDocument = "application/pdf"
    case PNGImage = "image/png"
    case GIFImage = "image/gif"
    case JPGImage = "image/jpeg"
    case DOCDocument = "application/msword"
    case DOCXDocument = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    case XLSDocument = "application/vnd.ms-excel"
    case XLSXDocument = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    
    var isImage: Bool {
        return self == PNGImage || self == GIFImage || self == JPGImage
    }
    var isDocument: Bool {
        return self == PDFDocument || self == DOCDocument || self == DOCXDocument || self == XLSDocument || self == XLSXDocument
    }
}
