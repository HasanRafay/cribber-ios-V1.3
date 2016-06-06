//
//  SettingsItemCell.swift
//  Cribber
//
//  Created by Resolve Digital on 14/10/15.
//  Copyright © 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit

class SettingsItemCell: UITableViewCell {
    static let borderWidth : CGFloat = 1.0
    static let borderColor = Styles.lightBlueGrayColor

    let backdropView = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        // Visible parts of background act as separator
        backgroundView = UIView()
        backgroundView!.backgroundColor = SettingsItemCell.borderColor

        selectedBackgroundView = UIView()
        selectedBackgroundView!.backgroundColor = Styles.lightBlueGrayColor

        backdropView.backgroundColor = Styles.darkBlueGrayColor
        contentView.insertSubview(backdropView, atIndex: 0)

        backdropView.snp_makeConstraints { make in
            make.top.equalTo(contentView.snp_top).offset(SettingsItemCell.borderWidth)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.bottom.equalTo(contentView.snp_bottom)
            return
        }

        textLabel!.backgroundColor = UIColor.clearColor()
        textLabel!.font = UIFont(name: Styles.latoBoldFontName, size: 16)!
        textLabel!.textColor = UIColor.whiteColor()

        textLabel!.text = textLabel?.text?.uppercaseString

        detailTextLabel?.backgroundColor = UIColor.clearColor()
        detailTextLabel?.font = UIFont(name: Styles.latoLightFontName, size: 14)!
        detailTextLabel?.textColor = UIColor.whiteColor()
    }
}
