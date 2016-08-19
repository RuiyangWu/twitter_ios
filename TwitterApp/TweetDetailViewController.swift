//
//  TweetDetailViewController.swift
//  TwitterApp
//
//  Created by ruiyang_wu on 8/18/16.
//  Copyright © 2016 ruiyang_wu. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    var tweet: Tweet! {
      didSet {
        view.layoutIfNeeded()
        userNameLabel.text = tweet.userName
        if tweet.userScreenName != nil {
          screenNameLabel.text = "@" + tweet.userScreenName!
        }
        tweetTextLabel.text = tweet.text
        if let profileImageUrl = tweet.profileImageUrl {
          profileImageView.setImageWithURL(profileImageUrl)
        }

        if let timestamp = tweet.timestamp {
          let formatter = NSDateFormatter()
          //formatter.dateFormat = "EEE MM d HH:mm:ss Z y"
          formatter.dateFormat = "MM/dd/yy, HH:mm:ss"
          timestampLabel.text = formatter.stringFromDate(timestamp)
          // "8/17/16, 8:55 PM"
        }
        else {
          timestampLabel.text = "N/A"
        }
      }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onBack(sender: AnyObject) {
      dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onRetweet(sender: AnyObject) {
      TwitterClient.sharedInstance.retweetById(String(tweet.id), success: { () in
          // Do nothing
        }, failure: {(error: NSError) in
          print("Error when Retweet-ing: ", error.localizedDescription)
      })
    }

    @IBAction func onFavorite(sender: AnyObject) {
      TwitterClient.sharedInstance.favoriteById(String(tweet.id), success: { () in
        // Do nothing
        }, failure: {(error: NSError) in
          print("Error when Favorit-ing: ", error.localizedDescription)
      })
    }

    @IBAction func onReply(sender: AnyObject) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
