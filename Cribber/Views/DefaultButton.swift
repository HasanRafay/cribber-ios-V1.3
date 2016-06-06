//
//  DefaultButton.swift
//  Cribber
//
//  Created by Tim Ross on 13/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

class DefaultButton: UIButton {
    override var enabled:Bool{
        didSet {
            self.alpha = enabled ? 1 : 0.4
            super.enabled = enabled
        }
    }
    
    convenience init () {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = 4

        backgroundColor = Styles.brightRedColor
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        titleLabel?.font = UIFont(name: Styles.latoBlackFontName, size: 15)!
    }
    
    override var highlighted: Bool {
        didSet {
            backgroundColor = backgroundColor!.colorWithAlphaComponent(highlighted ? 0.7 : 1)
        }
    }

    override func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(title?.uppercaseString, forState: state)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Ensure enabled setter is called when loaded from interface builder
        let enabled = self.enabled
        self.enabled = enabled
    }
}
