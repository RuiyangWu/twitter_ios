//
//  Tweet.swift
//  TwitterApp
//
//  Created by ruiyang_wu on 8/15/16.
//  Copyright © 2016 ruiyang_wu. All rights reserved.
//

import UIKit

class Tweet: NSObject {

  var text: NSString?
  var timestamp: NSDate?
  var retweetsCount: Int = 0
  var favoritesCount: Int = 0

  init(dictionary: NSDictionary) {
    text = dictionary["text"] as? String
    retweetsCount = (dictionary["retweet_count"] as? Int) ?? 0
    favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0

    let timestampString = dictionary["created_at"] as? String

    if let timestampString = timestampString {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "EEE MM d HH:mm:ss Z y"
      timestamp = formatter.dateFromString(timestampString)
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
