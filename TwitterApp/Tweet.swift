//
//  Tweet.swift
//  TwitterApp
//
//  Created by ruiyang_wu on 8/15/16.
//  Copyright © 2016 ruiyang_wu. All rights reserved.
//

import UIKit

class Tweet: NSObject {

  var id: Int!
  var text: String?
  var timestamp: NSDate?
  var retweetsCount: Int = 0
  var favoritesCount: Int = 0

  var userName: String?
  var userScreenName: String?
  var profileImageUrl: NSURL?

  init(dictionary: NSDictionary) {
    id = dictionary["id"] as! Int
    text = dictionary["text"] as? String
    retweetsCount = (dictionary["retweet_count"] as? Int) ?? 0
    favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0

    let timestampString = dictionary["created_at"] as? String

    if let timestampString = timestampString {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "EEE MM d HH:mm:ss Z y"
      timestamp = formatter.dateFromString(timestampString)
    }

    if let userDict = dictionary["user"] as? NSDictionary {
      userName = userDict["name"] as? String
      userScreenName = userDict["screen_name"] as? String
      if let urlString = userDict["profile_image_url"] as? String {
        profileImageUrl = NSURL(string: urlString)
      }
    }
  }

  class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
    var tweets = [Tweet]()
    for dictionary in dictionaries {
      let tweet = Tweet(dictionary: dictionary)
      tweets.append(tweet)
    }
    return tweets
  }
}
