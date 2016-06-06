//
//  AttachmentLoader.swift
//  Cribber
//
//  Created by Tim Ross on 15/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class AttachmentLoader {
    
    var delegate: AttachmentLoaderDelegate?
    private var downloadRequest: Request?
    
    func request(attachment: Attachment) {
        let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = {
            (temporaryURL, response) in
            
            let filename = response.suggestedFilename!
            let tempDirURL = NSURL(fileURLWithPath: NSTemporaryDirectory())
            let path = tempDirURL.URLByAppendingPathComponent(filename).path!
            
            // Ensure requested file doesn't already exist, or an error will occur
            if NSFileManager.defaultManager().fileExistsAtPath(path) {
                try! NSFileManager.defaultManager().removeItemAtPath(path)
            }
            
            attachment.localFilePath = path
            try! attachment.managedObjectContext!.save()
            
            return NSURL(fileURLWithPath: path)
        }
        
        SVProgressHUD.showWithStatus("Loading")
        downloadRequest = Alamofire.download(.GET, attachment.sourceURL, destination: destination)
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                let progress = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
                dispatch_async(dispatch_get_main_queue()) {
                    SVProgressHUD.showProgress(progress, status: "Loading")
                }
                return
            }
            .response { (request, response, _, error) in
                SVProgressHUD.dismiss()
                if error == nil {
                    self.load(attachment)
                } else if let error = error as? NSError {
                    Log.Error("Downloading attachment", error: error)
                    self.delegate?.attachmentLoader(self, didFailDownloadWithError: error)
                }
        }
    }
    
    func load(attachment: Attachment) {
        let previewItem = AttachmentPreviewItem(attachment: attachment)
        delegate?.attachmentLoader(self, didLoadAttachmentPreviewItem: previewItem)
    }
    
    func cancel() {
        downloadRequest?.cancel()
        SVProgressHUD.dismiss()
    }
}

protocol AttachmentLoaderDelegate {
    func attachmentLoader(attachmentLoader: AttachmentLoader, didLoadAttachmentPreviewItem previewItem: AttachmentPreviewItem)
    func attachmentLoader(attachmentLoader: AttachmentLoader, didFailDownloadWithError error: NSError)
}
