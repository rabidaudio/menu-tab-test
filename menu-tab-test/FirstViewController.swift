//
//  FirstViewController.swift
//  menu-tab-test
//
//  Created by fixd on 2/1/16.
//  Copyright © 2016 fixd. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func openLeftMenu(sender: AnyObject) {
//        MainContainerViewController.toggleLeftMenu()
        MenuContainerView.parentMenuContainer(self)?.toggleLeftMenu()
    }

    @IBAction func openRightMenu(sender: AnyObject) {
//        MainContainerViewController.toggleRightMenu()
        MenuContainerView.parentMenuContainer(self)?.toggleRightMenu()
    }
}

