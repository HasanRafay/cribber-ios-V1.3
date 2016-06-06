//
//  AttachmentCell.swift
//  Cribber
//
//  Created by Tim Ross on 9/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

class AttachmentCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        contentView.clipsToBounds = true
        
        imageView.layer.borderColor = Styles.grayColor.CGColor
        imageView.layer.borderWidth = 1
        imageView.tintColor = Styles.grayColor
        contentView.addSubview(imageView)
        
        imageView.snp_makeConstraints { make in
            make.edges.equalTo(self.contentView)
            return
        }
    }
    
    func updateFromAttachment(attachment: Attachment) {
        imageView.contentMode = .Center
        if attachment.previewURL != nil {
            let imageURL = NSURL(string: attachment.previewURL!)
            imageView.sd_setImageWithURL(imageURL, placeholderImage: attachment.placeholderImage(), completed: {
                (image, error, cacheType, imageURL) in
                if error == nil {
                    self.imageView.contentMode = .ScaleAspectFill
                }
            })
        } else {
            imageView.image = attachment.placeholderImage()
        }
    }
}
