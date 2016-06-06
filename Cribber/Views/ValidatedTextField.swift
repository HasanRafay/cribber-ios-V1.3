//
//  ValidatedTextField.swift
//  Cribber
//
//  Created by Tim Ross on 28/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

class ValidatedTextField: UITextField {
    var validationImageView: UIImageView!
    
    let checkmarkImage = UIImage(named: "icon-checkmark")
    let errorImage = UIImage(named: "icon-cancel")
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        validationImageView = UIImageView(frame: CGRectMake(0, 0, 40, 32))
        validationImageView.contentMode = .Left
        
        rightViewMode = .Always
        rightView = validationImageView
    }
    
    func displayIsValid(valid: Bool) {
        if valid {
            validationImageView.image = checkmarkImage
            validationImageView.tintColor = Styles.brightGreenColor
        } else {
            validationImageView.image = errorImage
            validationImageView.tintColor = Styles.brightRedColor
        }
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderColor = validationImageView.tintColor.CGColor
        layer.borderWidth = 1
    }
    
    func clearValidation() {
        validationImageView.image = nil
        validationImageView.tintColor = nil
        layer.borderColor = UIColor.clearColor().CGColor
    }
}
