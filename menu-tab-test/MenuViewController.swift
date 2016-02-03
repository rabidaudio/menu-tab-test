
//
//  MenuViewController.swift
//  menu-tab-test
//
//  Created by fixd on 2/1/16.
//  Copyright © 2016 fixd. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UITableViewController {
    
    let menuItems = ["One", "Two", "Three"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("menu loaded!", tableView.dataSource, tableView.delegate)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print("menu frame: ", view.frame)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        let item = menuItems[indexPath.row]
        cell!.textLabel?.text = item
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = menuItems[indexPath.row]
        print("selected \(item)")
        (parentViewController?.view as? MenuContainerView)?.closeMenu()
    }
    
}