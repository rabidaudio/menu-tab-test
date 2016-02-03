//
//  MyNavViewController.swift
//  menu-tab-test
//
//  Created by fixd on 2/3/16.
//  Copyright © 2016 fixd. All rights reserved.
//

import UIKit

class MyNavViewController: UIViewController {
    
    var menu: MenuContainerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu = parentViewController?.parentViewController?.view as? MenuContainerView
    }
    
    
    @IBAction func toggleLeftMenu(sender: AnyObject) {
        menu?.toggleLeftMenu()
    }
    
    @IBAction func toggleRightMenu(sender: AnyObject) {
        menu?.toggleRightMenu()
    }
    
}
