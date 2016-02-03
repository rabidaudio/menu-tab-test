//
//  MenuContainerViewController.swift
//  menu-tab-test
//
//  Created by fixd on 2/3/16.
//  Copyright © 2016 fixd. All rights reserved.
//

import UIKit

class MenuContainerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainViewController = storyboard!.instantiateViewControllerWithIdentifier("tabViewController")
        addChildViewController(mainViewController)
        
        let leftMenuController = storyboard!.instantiateViewControllerWithIdentifier("leftMenuController")
        addChildViewController(leftMenuController)
        
        print(mainViewController.view.bounds)
        
        let mainContainerView = view as! MenuContainerView
        mainContainerView.mainView = mainViewController.view
        mainContainerView.leftMenu = leftMenuController.view
    }
}