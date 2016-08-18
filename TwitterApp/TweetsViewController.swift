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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

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
          print(error.localizedDescription)
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
      return cell
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
