//
//  MyNavigationViewController.swift
//  menu-tab-test
//
//  Created by fixd on 2/3/16.
//  Copyright © 2016 fixd. All rights reserved.
//

import UIKit

class MyNavigationViewController: UIViewController {
    
    var menu: MenuContainerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu = parentViewController?.parentViewController?.view as? MenuContainerView
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("nav bounds", view.bounds)
    }
    
    
    @IBAction func toggleLeftMenu(sender: AnyObject) {
        menu?.toggleLeftMenu()
    }
    
    @IBAction func toggleRightMenu(sender: AnyObject) {
        menu?.toggleRightMenu()
    }
}