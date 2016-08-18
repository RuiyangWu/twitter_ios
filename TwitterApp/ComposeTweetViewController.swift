//
//  ComposeTweetViewController.swift
//  TwitterApp
//
//  Created by ruiyang_wu on 8/18/16.
//  Copyright © 2016 ruiyang_wu. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!

    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
      let user = User.currentUser!
      userNameLabel.text = user.name
      screenNameLabel.text = user.screenName

      if let profileImageUrl = user.profileUrl {
        profileImageView.setImageWithURL(profileImageUrl)
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(sender: AnyObject) {
      dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onTweet(sender: AnyObject) {
      print("About to tweet: ", textField.text)
      /*
      TwitterClient.sharedInstance.createTweet(textField.text!, success: { () in
        // Do nothing
        }, failure: {(error: NSError) in
          print("Error When Creating Tweet: ", error.localizedDescription)
      })
      */

      dismissViewControllerAnimated(true, completion: nil)
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
