//
//  TwitterClient.swift
//  TwitterApp
//
//  Created by ruiyang_wu on 8/15/16.
//  Copyright © 2016 ruiyang_wu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

  static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "9KL5nmGGmjkgdo8Uoy6d7H6dM", consumerSecret: "kFfJ4qR01rUfxg1UNXTPH9hF1yn6Iej4Pv7rAicwvGwjavXTmZ")

  var loginSuccess: (() -> ())?
  var loginFailure: ((NSError) -> ())?

  func currentAccount() {
    GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
      print("account: \(response)")
      let userDictionary = response as! NSDictionary
      let user = User(dictionary: userDictionary)

      print("name: ", user.name)
      print("screen name: ", user.screenName)
      print("profile image url: ", user.profileUrl)
      print("description: ", user.tagline)
      }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in

    })
  }

  func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
    GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
      let dictionaries = response as! [NSDictionary]
      let tweets = Tweet.tweetsWithArray(dictionaries)

      success(tweets)
    }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
      failure(error)
    })
  }

  func login(success: () -> (), failure: (NSError) -> ()) {
    loginSuccess = success
    loginFailure = failure

    deauthorize()
    fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
      print("I got a token!")

      let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
      UIApplication.sharedApplication().openURL(url)
    }) { (error: NSError!) -> Void in
      print("error: \(error.localizedDescription)")
      self.loginFailure?(error)
    }
  }

  func handleOpenUrl(url: NSURL) {
    let requestToken = BDBOAuth1Credential(queryString: url.query)
    fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
      self.loginSuccess?()
/*
      client.homeTimeline({ (tweets: [Tweet]) in
        for tweet in tweets {
          print("my tweet: ", tweet.text)
        }
        }, failure: { (error: NSError) in
          print(error.localizedDescription)
      })

      client.currentAccount()
 */
    }) { (error: NSError!) -> Void in
      print("error: \(error.localizedDescription)")
      self.loginFailure?(error)
    }
  }

}
