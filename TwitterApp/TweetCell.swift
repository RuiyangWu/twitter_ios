//
//  TweetCell.swift
//  TwitterApp
//
//  Created by ruiyang_wu on 8/15/16.
//  Copyright © 2016 ruiyang_wu. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userScreenNameLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!

  var tweet: Tweet! {
    didSet {
      userNameLabel.text = tweet.userName
      if tweet.userScreenName != nil {
        userScreenNameLabel.text = "@" + tweet.userScreenName!
      }
      tweetTextLabel.text = tweet.text
      timestampLabel.text = "2h" // TODO
      if let profileImageUrl = tweet.profileImageUrl {
        print("url: ", profileImageUrl)
        profileImageView.setImageWithURL(profileImageUrl)
      }
    }
  }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
