//
//  MainContainerViewController.swift
//  menu-tab-test
//
//  Created by fixd on 2/2/16.
//  Copyright © 2016 fixd. All rights reserved.
//

import Foundation
import UIKit

class MainContainerViewController: UIViewController {
    
    // adjust the menu size as a percentage of total screen space
    var menuWidthPercentage: CGFloat = 0.625 {
        didSet {
            configureViews()
        }
    }
    
    // should menu openings and closings be animated
    var animated = true
    
    private var scrollView = UIScrollView()
    
    // container view for main content
    private var mainContainerView = UIView()
    
    // tell the controller which view to use for left menu (e.g. storyboard.instantiateViewControllerWithIdentifier)
    var leftMenu: UIView? {
        willSet {
            leftMenu?.removeFromSuperview()
        }
        didSet {
            if leftMenu != nil {
                scrollView.addSubview(leftMenu!)
                configureViews()
            }
        }
    }
    
    // same for right
    var rightMenu: UIView? {
        willSet {
            rightMenu?.removeFromSuperview()
        }
        didSet {
            if rightMenu != nil {
                scrollView.addSubview(rightMenu!)
                configureViews()
            }
        }
    }
    
    var mainView: UIView? {
        willSet {
            mainContainerView.clearSubviews()
        }
        didSet {
            if mainView != nil {
                mainContainerView.addSubview(mainView!)
                configureViews()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configure scrollView
        scrollView.scrollEnabled = false
        scrollView.bounces = false
        scrollView.pagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1
        
        //add scrollview to view
        view.addSubview(scrollView)
        
        // add container to scrollView
        scrollView.addSubview(mainContainerView)
        
        // configure gestures
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: "leftSwipe")
        leftSwipe.direction = .Left
        view.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: "rightSwipe")
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
        
        mainContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "mainViewTap"))
        
        
        // listen for open/close notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleLeftMenu", name: "toggleLeftMenu", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleRightMenu", name: "toggleRightMenu", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeMenu", name: "closeMenu", object: nil)
    }
    
    deinit {
        //stop listening to notifications
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // calculate the bounds of all the views
    private func configureViews() {
        // make the scrollView fill up the screen
        scrollView.frame = view.bounds
        
        //make the scroll view's total content area be the full screen plus the left and right menus
        let scrollViewSize = CGSize(width: screenSize.width + 2*menuWidth, height: screenSize.height)
        scrollView.contentSize = scrollViewSize
        
        //set the scroll view's starting point to the main content
        scrollView.contentOffset = mainOrigin
        
        //make the main view fill up the whole screen
        mainContainerView.frame = CGRect(origin: mainOrigin, size: screenSize)
        
        if leftMenu != nil {
            //make the left menu fill the correct space
            leftMenu!.frame = CGRect(origin: leftOrigin, size: menuSize)
        }
        
        if rightMenu != nil {
            //make the left menu fill the correct space
            rightMenu!.frame = CGRect(origin: rightOrigin, size: menuSize)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureViews()
    }
    
    // math
    
    //the width of menus in pixels
    private var menuWidth: CGFloat {
        return screenSize.width * menuWidthPercentage
    }
    
    // the origin cordinate in the scroll view for the mainContainerView
    private var mainOrigin: CGPoint {
        return CGPoint(x: menuWidth, y: 0)
    }
    
    // the origin cordinate for the left menu
    private var leftOrigin: CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    // the origin cordinate for the right menu
    private var rightOrigin: CGPoint {
        return CGPoint(x: scrollView.contentSize.width - view.bounds.width, y: 0)
    }
    
    // the total visible screen size
    private var screenSize: CGSize {
        return view.bounds.size
    }
    
    private var menuSize: CGSize {
        return CGSize(width: menuWidth, height: screenSize.height)
    }
    
    var isLeftMenuOpen: Bool {
        return scrollView.contentOffset.x < menuWidth
    }
    
    var isRightMenuOpen: Bool {
        return scrollView.contentOffset.x > menuWidth
    }
    
    var isMenuOpen: Bool {
        return scrollView.contentOffset.x != menuWidth
    }
    
    func openLeftMenu(){
        if leftMenu != nil {
            scrollView.scrollRectToVisible(CGRect(origin: leftOrigin, size: screenSize), animated: animated)
        }
    }
    
    func openRightMenu(){
        if rightMenu != nil {
            scrollView.scrollRectToVisible(CGRect(origin: rightOrigin, size: screenSize), animated: animated)
        }
    }
    
    func toggleLeftMenu() {
        if isLeftMenuOpen {
            closeMenu()
        }else{
            openLeftMenu()
        }
    }
    
    func toggleRightMenu() {
        if isRightMenuOpen {
            closeMenu()
        }else{
            openRightMenu()
        }
    }
    
    func closeMenu(){
        scrollView.scrollRectToVisible(mainContainerView.frame, animated: animated)
    }
    
    // gesture listeners
    func mainViewTap(){
        if isMenuOpen {
            closeMenu()
        }
    }
    
    func leftSwipe(){
        if isLeftMenuOpen {
            closeMenu()
        } else if !isRightMenuOpen {
            openRightMenu()
        }
    }
    
    func rightSwipe(){
        if isRightMenuOpen {
            closeMenu()
        }else if !isLeftMenuOpen {
            openLeftMenu()
        }
    }
    

    // helper shortcuts for menu operations
    static func toggleLeftMenu(){
        NSNotificationCenter.defaultCenter().postNotificationName("toggleLeftMenu", object: nil)
    }
    
    static func toggleRightMenu(){
        NSNotificationCenter.defaultCenter().postNotificationName("toggleRightMenu", object: nil)
    }
    
    static func closeMenu(){
        NSNotificationCenter.defaultCenter().postNotificationName("closeMenu", object: nil)
    }
}

extension UIView {
    private func clearSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}