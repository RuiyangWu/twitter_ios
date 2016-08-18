//
//  ProfileViewController.swift
//  TwitterApp
//
//  Created by ruiyang_wu on 8/17/16.
//  Copyright © 2016 ruiyang_wu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var countTweetsLabel: UILabel!
    @IBOutlet weak var countFollowingLabel: UILabel!
    @IBOutlet weak var countFollowersLabel: UILabel!

    //var userScreenName: String? {
    var userScreenName: String? {
      didSet {
        TwitterClient.sharedInstance.getUserByScreenName(userScreenName!, success: { (resultUser: User) in
          self.user = resultUser
          }, failure: { (error: NSError) in
            print("Error getting user by screen name: ", error.localizedDescription)
        })
      }
    }

    var user: User? {
      didSet {
        view.layoutIfNeeded()
        userNameLabel.text = user?.name
        screenNameLabel.text = user?.screenName
        descriptionLabel.text = user?.tagline

        countTweetsLabel.text = String(user!.countTweets!)
        countFollowersLabel.text = String(user!.countFollowers!)
        countFollowingLabel.text = String(user!.CountFollowing!)

        if let profileImageUrl = user?.profileUrl {
          profileImage.setImageWithURL(profileImageUrl)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
