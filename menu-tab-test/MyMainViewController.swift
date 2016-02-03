//
//  MyMainViewController.swift
//  menu-tab-test
//
//  Created by fixd on 2/2/16.
//  Copyright © 2016 fixd. All rights reserved.
//

import UIKit

class MyMainViewController: MainContainerViewController {
    
    override func viewDidLoad() {
        
        mainView = storyboard!.instantiateViewControllerWithIdentifier("tabViewController").view
        leftMenu = storyboard!.instantiateViewControllerWithIdentifier("leftMenuController").view
        
        super.viewDidLoad()
    }
}
