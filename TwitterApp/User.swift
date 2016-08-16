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

  init(dictionary: NSDictionary) {
    name = dictionary["name"] as! String
    screenName = dictionary["screen_name"] as! String

    let profileUrlString = dictionary["profile_image_url_https"] as? String
    if let profileUrlString = profileUrlString {
      profileUrl = NSURL(string: profileUrlString)
    }

    tagline = dictionary["description"] as! String
  }

}
