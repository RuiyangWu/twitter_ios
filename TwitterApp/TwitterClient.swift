//
//  TwitterClient.swift
//  TwitterApp
//
//  Created by ruiyang_wu on 8/15/16.
//  Copyright © 2016 ruiyang_wu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import AFNetworking

class TwitterClient: BDBOAuth1SessionManager {

  static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "9KL5nmGGmjkgdo8Uoy6d7H6dM", consumerSecret: "kFfJ4qR01rUfxg1UNXTPH9hF1yn6Iej4Pv7rAicwvGwjavXTmZ")

  var loginSuccess: (() -> ())?
  var loginFailure: ((NSError) -> ())?

  /* Load Current User Account */
  func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
    GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
      let userDictionary = response as! NSDictionary
      let user = User(dictionary: userDictionary)

      success(user)

      }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
        failure(error)
    })
  }

  /* Get Home Timeline */
  func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
    GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
      let dictionaries = response as! [NSDictionary]
      let tweets = Tweet.tweetsWithArray(dictionaries)

      success(tweets)
    }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
      failure(error)
    })
  }

  /* Login First Step -- Get request token from Twitter */
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

  /* Login Complete Step -- Get Access Token */
  func handleOpenUrl(url: NSURL) {
    let requestToken = BDBOAuth1Credential(queryString: url.query)
    fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
      self.currentAccount({ (user: User) in
        User.currentUser = user
        self.loginSuccess?()
      }, failure: { (error: NSError) in
        self.loginFailure?(error)
      })
    }) { (error: NSError!) -> Void in
      print("error: \(error.localizedDescription)")
      self.loginFailure?(error)
    }
  }

  /* Logout Current User */
  func logout() {
    User.currentUser = nil
    deauthorize()

    NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
  }

  /* Get User By Screen Name */
  func getUserByScreenName(screenName: String, success: (User) -> (), failure: (NSError) -> ()) {
    print("In getUserByScreenName")
    GET("1.1/users/show.json", parameters: ["screen_name": screenName], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
      let userDictionary = response as! NSDictionary
      let user = User(dictionary: userDictionary)

      success(user)

      }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
        failure(error)
    })
  }

  /* Post - Retweet */
  func retweetById(id: String, success: () -> (), failure: (NSError) -> ()) {
    print("In retweetById")
    POST("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask?, response: AnyObject?) -> Void in
      print("Retweet good! :)")
      success()
    }) { (task: NSURLSessionDataTask?, error: NSError) in
      print("Retweet bad :(")
      failure(error)
    }
  }

  /* Post - Favorite */
  func favoriteById(id: String, success: () -> (), failure: (NSError) -> ()) {
    print("In favoriteById")
    POST("1.1/favorites/create.json", parameters: ["id": id], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
      print("Favorite good! :)")
      success()
    }) { (task: NSURLSessionDataTask?, error: NSError) in
      print("Favorite bad :(")
      failure(error)
    }
  }

  /* Post - createTweet */
  func createTweet(text: String, success: () -> (), failure: (NSError) -> ()) {
    print("In favoriteById")
    POST("1.1/statuses/update.json", parameters: ["status": text], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
      print("Create Tweet good! :)")
      success()
    }) { (task: NSURLSessionDataTask?, error: NSError) in
      print("Create Tweet bad :(")
      failure(error)
    }
  }

}
