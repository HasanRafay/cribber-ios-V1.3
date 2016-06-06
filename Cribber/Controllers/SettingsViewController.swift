//
//  SettingsViewController.swift
//  Cribber
//
//  Created by Tim Ross on 20/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    var authenticationManager: AuthenticationManager!
    var stationManager: StationManager!
    var stations = [Station]()
    
    private let StationSection = Int(0)
    private let AboutSection = Int(1)
    private let PrivacyPolicyRow = Int(1)
    private let TermsOfServiceRow = Int(2)
    private let FeedbackRow = Int(3)
    private let SignOutRow = Int(4)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticationManager = AuthenticationManager.sharedInstance
        stationManager = StationManager()
        
        versionLabel.text = UIApplication.versionBuild()
        stations = stationManager.loadStations()

        tableView.backgroundColor = Styles.lightBlueColor
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        AnalyticsManager.sharedInstance.sendScreenView("Settings")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == StationSection {
            return stations.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }

    func rowIsSelectable(row : Int) -> Bool {
        return row == PrivacyPolicyRow
            || row == TermsOfServiceRow
            || row == FeedbackRow
            || row == SignOutRow
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == StationSection {
            let cellIdentifier = "StationCell"
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
            if cell == nil {
                cell = SettingsItemCell(style: .Default, reuseIdentifier:cellIdentifier)
            }

            cell!.selectionStyle = .None

            let station = stations[indexPath.row]
            cell!.textLabel!.text = station.name.uppercaseString

            return cell!
        } else {
            let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
            if rowIsSelectable(indexPath.row) {
                cell.selectionStyle = .Default
            }

            return cell
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView

        headerView.textLabel!.font = UIFont(name: Styles.latoBoldFontName, size: 16)!
        headerView.textLabel!.textColor = UIColor.whiteColor()
    }

    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Add a border view to the bottom of the section (to complement the 1pt
        // border at that top of every SettingsItemCell):
        let view = UIView()
        view.backgroundColor = SettingsItemCell.borderColor

        return view
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return SettingsItemCell.borderWidth
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == AboutSection {
            if indexPath.row == PrivacyPolicyRow {
                Constants.PrivacyPolicyURL.openInSafari()
            } else if indexPath.row == TermsOfServiceRow {
                Constants.TermsOfServiceURL.openInSafari()
            } else if indexPath.row == FeedbackRow {
                feedback()
            } else if indexPath.row == SignOutRow {
                signout()
            }
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == StationSection {
            if stations.count == 0 {
                return NSLocalizedString("StationSectionEmptyFooter", comment: "")
            }
        }
        return super.tableView(tableView, titleForFooterInSection: section)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == StationSection {
            return CGFloat(44)
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if indexPath.section == StationSection {
            return 0
        }
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    func feedback() {
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setSubject(Constants.FeedbackSubject)
        picker.setToRecipients([Constants.FeedbackRecipient])
        
        if MFMailComposeViewController.canSendMail() {
            presentViewController(picker, animated: true, completion: {
                UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
            })
        }
    }
    
    func signout() {
        dismissViewControllerAnimated(false, completion: {
            self.authenticationManager.signout()
        })
    }
    
    // MARK: - MFMailComposeViewControllerDelegate methods
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
