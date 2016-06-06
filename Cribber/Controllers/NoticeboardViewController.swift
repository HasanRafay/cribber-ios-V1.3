//
//  NoticeboardViewController.swift
//  Cribber
//
//  Created by Tim Ross on 23/03/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD
import Reachability
import SevenSwitch

class NoticeboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, InvitationCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var pinnedItemsSwitch: SevenSwitch!
    
    let refreshControl = UIRefreshControl()
    
    var feedManager: FeedManager!
    var invitationManager: InvitationManager!
    var stationManager: StationManager!
    var dataStore: CoreDataStore!
    
    var contentOffsetDictionary = [Int: CGFloat]()
    var feedItems = [FeedItemInfo]()
    
    func refreshData() {
        if !refreshControl.refreshing {
            refreshControl.beginRefreshing()
            refreshControl.sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    func loadFeedItems() {
        feedItems = feedManager.loadFeedItems(onlyPinned:
            pinnedItemsSwitch.on)
        if feedItems.count == 0 && stationManager.countStations() == 0 {
            feedItems.append(NoStationFeedItem())
        }
        emptyStateView.hidden = feedItems.count > 0
    }
    
    func feedItemAtIndex(index: Int) -> FeedItemInfo {
        return feedItems[index]
    }
    
    // MARK: - UIViewController methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedManager = FeedManager()
        invitationManager = InvitationManager()
        stationManager = StationManager()
        dataStore = CoreDataStore()
        
        view.backgroundColor = Styles.grayColor
        
        refreshControl.addTarget(self, action: #selector(NoticeboardViewController.refresh(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(NoticeboardViewController.userDidSignIn), name: Constants.UserDidSignInNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(NoticeboardViewController.refreshData), name: Constants.ApplicationDidReceiveRemoteNotification, object: nil)
        
        loadFeedItems()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        AnalyticsManager.sharedInstance.sendScreenView("Noticeboard")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "attachmentPreviewSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! AttachmentPreviewController
            controller.attachment = sender as! Attachment
        }
    }
    
    func userDidSignIn() {
        let reachability = Reachability.reachabilityForInternetConnection()
        if reachability.currentReachabilityStatus() != .NotReachable {
            refreshData()
        }
    }
    
    // MARK: - IBAction methods
    
    func refresh(refreshControl: UIRefreshControl) {
        self.feedManager.fetchFeed({
            error in
            self.loadFeedItems()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            if error != nil {
                self.showErrorAlert(error!)
            }
        })
    }
    
    @IBAction func unwindToNoticeboard(segue: UIStoryboardSegue) {
    }

    @IBAction func togglePinnedItems() {
        loadFeedItems()
        self.tableView.reloadData()
    }

    // MARK: - UITableViewDataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let feedItem = feedItemAtIndex(indexPath.row)
        
        let reuseIdentifier = "\(feedItem.feedItemType.capitalizedString)Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! FeedItemCell

        cell.updateFromFeedItem(feedItem)
        
        // Determines whether to show the attachments collection view
        cell.shouldDisplayAttachments = feedItem.attachments.count > 0
        cell.setNeedsUpdateConstraints()
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let feedItemCell = cell as? FeedItemCell {
            feedItemCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, indexPath: indexPath)
            let index = feedItemCell.collectionView.tag
            let horizontalOffset = contentOffsetDictionary[index] ?? 0
            feedItemCell.collectionView.setContentOffset(CGPointMake(horizontalOffset, 0), animated: false)
        }
        if let invitationCell = cell as? InvitationCell {
            invitationCell.delegate = self
        }
        // Ensure cell has clear background color
        cell.backgroundColor = UIColor.clearColor()
    }

    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let feedItemCell = cell as? FeedItemCell {
            feedItemCell.removeCollectionViewDataSourceDelegate()
        }
    }
    
    // MARK: - UICollectionViewDataSource methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let feedItem = feedItemAtIndex(collectionView.tag)
        return feedItem.attachments.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AttachmentCell", forIndexPath: indexPath) as! AttachmentCell
        
        let feedItem = feedItemAtIndex(collectionView.tag)
        let attachment = feedItem.attachments[indexPath.row] as! Attachment
        cell.updateFromAttachment(attachment)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let feedItem = feedItemAtIndex(collectionView.tag)
        let maxWidth = collectionView.frame.width
        var itemWidth = Constants.AttachmentItemHeight
        if feedItem.attachments.count == 1 {
            itemWidth = maxWidth
        } else if feedItem.attachments.count == 2 {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            itemWidth = (maxWidth / 2) - (layout.minimumInteritemSpacing / 2)
        }
        return CGSizeMake(itemWidth, Constants.AttachmentItemHeight)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let feedItem = feedItemAtIndex(collectionView.tag)
        let attachment = feedItem.attachments[indexPath.row] as! Attachment
        previewAttachment(attachment)
    }
    
    func previewAttachment(attachment: Attachment) {
        performSegueWithIdentifier("attachmentPreviewSegue", sender: attachment)
    }
    
    // MARK: - UIScrollViewDelegate methods
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            let horizontalOffset = collectionView.contentOffset.x
            contentOffsetDictionary[collectionView.tag] = horizontalOffset
        }
    }
    
    // MARK: - InvitationCellDelegate methods
    
    func invitationCellDidAccept(cell: InvitationCell) {
        let indexPath = tableView.indexPathForCell(cell)!
        let feedItem = feedItemAtIndex(indexPath.row)
        SVProgressHUD.show()
        invitationManager.acceptInvitation(feedItem as! FeedItem, completion: {
            error in
            SVProgressHUD.dismiss()
            if error != nil {
                self.showErrorAlert(error!)
            } else {
                
                AnalyticsManager.sharedInstance.sendEvent(category: "Accepting Team Invitation", action: "User accepted team invitation.")
                self.refreshData()
            }
        })
    }
}
