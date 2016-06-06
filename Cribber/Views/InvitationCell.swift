//
//  InvitationCell.swift
//  Cribber
//
//  Created by Tim Ross on 13/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

class InvitationCell: FeedItemCell {
    let acceptButton = DefaultButton()
    var delegate: InvitationCellDelegate?
    
    override func setupView() {
        super.setupView()

        containerView.backgroundColor = Styles.lightBlueColor

        // Darker blue bottom border:
        borderColor = Styles.darkBlueColor

        subjectLabel.textColor = UIColor.whiteColor()
        fromLabel.textColor = Styles.darkYellowColor
        messageLabel.textColor = UIColor.whiteColor()

        messageLabel.snp_remakeConstraints { make in
            make.top.equalTo(self.logoImageView.snp_bottom).offset(6)
            make.left.equalTo(self.containerView.snp_leftMargin)
            make.bottom.equalTo(self.collectionView.snp_top)
            make.right.equalTo(self.containerView.snp_rightMargin)
            return
        }

        collectionView.snp_removeConstraints()
        collectionView.hidden = true

        acceptButton.setTitle(NSLocalizedString("Accept", comment: ""), forState: UIControlState.Normal)
        acceptButton.addTarget(self, action: #selector(InvitationCell.accept), forControlEvents: .TouchUpInside)
        containerView.addSubview(acceptButton)
        
        acceptButton.snp_makeConstraints { make in
            make.top.equalTo(self.messageLabel.snp_bottom).offset(10)
            make.left.equalTo(self.containerView.snp_leftMargin)
            make.bottom.equalTo(self.containerView.snp_bottomMargin)
            make.right.equalTo(self.containerView.snp_rightMargin)
            make.height.equalTo(44).priorityHigh()
            return
        }
    }
    
    func accept() {
        delegate?.invitationCellDidAccept(self)
    }
}

protocol InvitationCellDelegate {
    func invitationCellDidAccept(cell: InvitationCell)
}
