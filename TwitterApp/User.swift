//
//  User.swift
//  TwitterApp
//
//  Created by ruiyang_wu on 8/15/16.
//  Copyright © 2016 ruiyang_wu. All rights reserved.
//

import UIKit

class User: NSObject {

  var name: String?
  var screenName: String?
  var profileUrl: NSURL?
  var tagline: String?

  var countTweets: Int?
  var countFollowers: Int?
  var CountFollowing: Int?

  var dictionary: NSDictionary?

  init(dictionary: NSDictionary) {
    self.dictionary = dictionary

    name = dictionary["name"] as? String
    screenName = dictionary["screen_name"] as? String

    let profileUrlString = dictionary["profile_image_url_https"] as? String
    if let profileUrlString = profileUrlString {
      profileUrl = NSURL(string: profileUrlString)
    }

    tagline = dictionary["description"] as? String

    if let countTweetsInDict = dictionary["statuses_count"] as? Int {
      countTweets = countTweetsInDict
    }
    if let countFollowersInDict = dictionary["followers_count"] as? Int {
      countFollowers = countFollowersInDict
    }
    if let countFollowingInDict = dictionary["friends_count"] as? Int {
      CountFollowing = countFollowingInDict
    }
  }

  static let userDidLogoutNotification = "UserDidLogout"

  static var _currentUser: User?

  class var currentUser: User? {
    get {
      if _currentUser == nil {
        let defaults = NSUserDefaults.standardUserDefaults()

        let userData = defaults.objectForKey("currentUserData") as? NSData

        if let userData = userData {
          let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary

          _currentUser = User(dictionary: dictionary)
        }
      }

      return _currentUser
    }

    set(user) {
      _currentUser = user

      let defaults = NSUserDefaults.standardUserDefaults()

      if let user = user {
        let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
        defaults.setObject(data, forKey: "currentUserData")
      }
      else {
        defaults.setObject(nil, forKey: "currentUserData")
      }

      defaults.synchronize()
    }
  }

}
