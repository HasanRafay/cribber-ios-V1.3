//
//  AttachmentPreviewController.swift
//  Cribber
//
//  Created by Tim Ross on 10/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

class AttachmentPreviewController: UIViewController, UIWebViewDelegate, AttachmentLoaderDelegate {
    
    var attachment: Attachment!
    var attachmentLoader: AttachmentLoader!
    var isPresented = true
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = attachment.feedItem.subject
        
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        
        attachmentLoader = AttachmentLoader()
        attachmentLoader.delegate = self
        attachmentLoader.load(attachment)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        AnalyticsManager.sharedInstance.sendScreenView("Attachment")
        
        if (attachment.localFilePath == nil ||
            NSFileManager.defaultManager().fileExistsAtPath(attachment.localFilePath!) == false) {
            attachmentLoader.request(attachment)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        attachmentLoader.cancel()
    }
    
    @IBAction func dismiss() {
        isPresented = false
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func attachmentLoader(attachmentLoader: AttachmentLoader, didLoadAttachmentPreviewItem previewItem: AttachmentPreviewItem) {
        if let previewItemURL = previewItem.URL {
            let request = NSURLRequest(URL: previewItemURL)
            webView.loadRequest(request)
        }
    }
    
    func attachmentLoader(attachmentLoader: AttachmentLoader, didFailDownloadWithError error: NSError) {
        showErrorAlert(error)
    }
}
