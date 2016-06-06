//
//  PhoneNumberField.swift
//  Cribber
//
//  Created by Tim Ross on 25/03/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

@IBDesignable
class PhoneNumberField: ValidatedTextField {
    var prefixButton: UIButton!
    
    @IBOutlet weak var phoneNumberDelegate: PhoneNumberFieldDelegate?
    
    @IBInspectable var prefixLabel: String = "+61" {
        didSet {
            prefixButton.setTitle(prefixLabel, forState: .Normal)
        }
    }
    @IBInspectable var prefixBackgroundColor: UIColor = UIColor.redColor() {
        didSet {
            prefixButton.backgroundColor = prefixBackgroundColor
        }
    }
    @IBInspectable var prefixTextColor: UIColor = UIColor.whiteColor() {
        didSet {
            prefixButton.setTitleColor(prefixTextColor, forState: .Normal)
        }
    }
    
    var phoneNumber: PhoneNumber? {
        let text = self.text!.stringByRemovingSpaces()
        if let number = Int(text) {
            return PhoneNumber(prefix: Int(self.prefixLabel)!, number: number)
        }
        return nil
    }
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        prefixButton = UIButton(frame: CGRectMake(0, 0, 44, 44))
        prefixButton.addTarget(self, action: #selector(PhoneNumberField.prefixButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        let maskLayer = CAShapeLayer();
        maskLayer.path = UIBezierPath(roundedRect: prefixButton.bounds, byRoundingCorners: [.TopLeft, .BottomLeft], cornerRadii: CGSizeMake(5.0, 5.0)).CGPath
        prefixButton.layer.mask = maskLayer;
        
        leftViewMode = .Always
        leftView = prefixButton
    }
    
    func prefixButtonPressed(sender: UIButton) {
        phoneNumberDelegate?.phoneNumberFieldDidSelectChangePrefix?(self)
    }
    
    override func leftViewRectForBounds(bounds: CGRect) -> CGRect {
        return prefixButton.frame
    }
}

@objc protocol PhoneNumberFieldDelegate : NSObjectProtocol {
    optional func phoneNumberFieldDidSelectChangePrefix(field: PhoneNumberField!)
}
