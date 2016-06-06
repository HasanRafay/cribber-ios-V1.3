//
//  Styles.swift
//  Cribber
//
//  Created by Tim Ross on 2/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

struct Styles {
    static let darkBlueColor = UIColor(hex: 0x263746)
    static let lightBlueColor = UIColor(hex: 0x3A4856)

    static let darkBlueGrayColor = UIColor(hex: 0x606972)
    static let lightBlueGrayColor = UIColor(hex: 0x8D939A)

    static let darkYellowColor = UIColor(hex: 0xFFB22D)
    static let lightYellowColor = UIColor(hex: 0xFFC157)

    static let brightRedColor = UIColor(hex: 0xFF2D11)
    static let lightRedColor = UIColor(hex: 0xFF5741)

    static let brightGreenColor = UIColor(hex: 0x3AAA35)
    static let lightGreenColor = UIColor(hex: 0x61BB5D)

    static let darkestGrayColor = UIColor(hex: 0x575756)
    static let darkGrayColor = UIColor(hex: 0xB2B2B2)
    static let grayColor = UIColor(hex: 0xDADADA)
    static let lightGrayColor = UIColor(hex: 0xEDEDED)
    static let lightestGrayColor = UIColor(hex: 0xF4F4F4)

    static let latoRegularFontName = "Lato-Regular"
    static let latoBoldFontName = "Lato-Bold"
    static let latoBlackFontName = "Lato-Black"
    static let latoLightFontName = "Lato-Light"

    static func setupAppearance()
    {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.translucent = false
        navBarAppearance.barTintColor = darkBlueColor
        navBarAppearance.tintColor = darkYellowColor
        navBarAppearance.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: latoBoldFontName, size: 26)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.setTitleTextAttributes([NSForegroundColorAttributeName: lightYellowColor], forState: .Normal)
    }
}
