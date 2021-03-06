//
//  HamburgerViewController.swift
//  TwitterApp
//
//  Created by ruiyang_wu on 8/16/16.
//  Copyright © 2016 ruiyang_wu. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    var originalLeftMargin: CGFloat!

    var menuViewController: UIViewController! {
      didSet {
        view.layoutIfNeeded()
        menuView.addSubview(menuViewController.view)
      }
    }

    var contentViewController: UIViewController! {
      didSet(oldContentViewController) {
        view.layoutIfNeeded()

        if oldContentViewController != nil {
          oldContentViewController.willMoveToParentViewController(nil)
          oldContentViewController.view.removeFromSuperview()
          oldContentViewController.didMoveToParentViewController(nil)
        }

        contentViewController.willMoveToParentViewController(self)
        contentView.addSubview(contentViewController.view)
        contentViewController.didMoveToParentViewController(self)

        closeMenu()
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
    
    @IBAction func onPanGuesture(sender: UIPanGestureRecognizer) {
      let translation = sender.translationInView(view)
      let velocity = sender.velocityInView(view)

      if sender.state == UIGestureRecognizerState.Began {
        originalLeftMargin = leftMarginConstraint.constant
      }
      else if sender.state == UIGestureRecognizerState.Changed {
        leftMarginConstraint.constant = originalLeftMargin + translation.x
      }
      else if sender.state == UIGestureRecognizerState.Ended {
        UIView.animateWithDuration(0.5, animations: { 
          if velocity.x > 0 {
            self.leftMarginConstraint.constant = self.view.frame.size.width - 200
          }
          else {
            self.leftMarginConstraint.constant = 0
          }
          self.view.layoutIfNeeded()
        })
      }
    }

    private func closeMenu() {
      UIView.animateWithDuration(0.3) { () -> Void in
        self.leftMarginConstraint.constant = 0
        self.view.layoutIfNeeded()
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
