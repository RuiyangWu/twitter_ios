//
//  TweetsViewController.swift
//  TwitterApp
//
//  Created by ruiyang_wu on 8/15/16.
//  Copyright © 2016 ruiyang_wu. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var tweets: [Tweet]!

    var dict = [UIGestureRecognizer : Tweet]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        // Navigation Bar Customization
        if let navigationBar = navigationController?.navigationBar {
          navigationBar.backgroundColor = UIColor(red: CGFloat(85)/255.0, green: CGFloat(172)/255.0, blue: CGFloat(238)/255.0, alpha: 0.8)

          navigationBar.titleTextAttributes = [
            NSFontAttributeName : UIFont.boldSystemFontOfSize(22),
            NSForegroundColorAttributeName : UIColor(red: CGFloat(85)/255.0, green: CGFloat(172)/255.0, blue: CGFloat(238)/255.0, alpha: 0.8)
          ]
        }

        // Pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getTweets(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        // Get initial tweets
        getTweets(refreshControl)
    }

    func getTweets(refreshControl: UIRefreshControl) {
      TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
        self.tweets = tweets
        self.tableView.reloadData()
        refreshControl.endRefreshing()
      }, failure: { (error: NSError) in
          print("getTweets error: ", error.localizedDescription)
      })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return tweets?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
      cell.tweet = tweets[indexPath.row]

      cell.profileImageView.userInteractionEnabled = true
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TweetsViewController.onCustomTap(_:)))
      cell.profileImageView.addGestureRecognizer(tapGestureRecognizer)
      dict[tapGestureRecognizer] = tweets[indexPath.row]

      return cell
    }

    func onCustomTap(tapGestureRecognizer: UITapGestureRecognizer) {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let nc = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as! UINavigationController
      let vc = nc.topViewController as! ProfileViewController
      vc.userScreenName = dict[tapGestureRecognizer]?.userScreenName! // User.currentUser?.screenName
      self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onLogoutButton(sender: AnyObject) {
      TwitterClient.sharedInstance.logout()
    }

    /*
    // MARK: - Navigation
    */

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
      if let cell = sender as? TweetCell {
        let indexPath = tableView.indexPathForCell(cell)!
        let tweet = tweets[indexPath.row]

        let navigationController = segue.destinationViewController as! UINavigationController
        let tweetDetailViewController = navigationController.topViewController as! TweetDetailViewController
        tweetDetailViewController.tweet = tweet
      }
    }

}
