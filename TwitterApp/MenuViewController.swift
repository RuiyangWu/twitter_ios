//
//  MenuViewController.swift
//  TwitterApp
//
//  Created by ruiyang_wu on 8/16/16.
//  Copyright © 2016 ruiyang_wu. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var viewControllers: [UIViewController] = []

    private var tweetsNavigationController: UIViewController!
    private var profileNavigationController: UIViewController!

    var hamburgerViewController: HamburgerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tweetsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController")
        profileNavigationController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController")

        viewControllers.append(tweetsNavigationController)
        viewControllers.append(profileNavigationController)

        hamburgerViewController.contentViewController = tweetsNavigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 2 // 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell") as! MenuCell
      switch indexPath.row {
      case 0: cell.nameLabel.text = "Home Page"
      case 1: cell.nameLabel.text = "Profile"
      //case 2: cell.nameLabel.text = "Mentions"
      default: break
      }
      return cell
    }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    hamburgerViewController.contentViewController = viewControllers[indexPath.row]

    if indexPath.row == 1 { // Profile page
      let nc = viewControllers[indexPath.row] as! UINavigationController
      let vc = nc.topViewController as! ProfileViewController
      vc.userScreenName = User.currentUser?.screenName
    }
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
