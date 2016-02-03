//
//  MainContainerViewController.swift
//  menu-tab-test
//
//  Created by fixd on 2/2/16.
//  Copyright © 2016 fixd. All rights reserved.
//

import UIKit

class MenuContainerView: UIView {
    
    // adjust the menu size as a percentage of total screen space
    var menuWidthPercentage: CGFloat = 0.625 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // should menu openings and closings be animated
    var animated = true
    
    private var scrollView = UIScrollView()
    
    // container view for main content
    private var mainContainerView = UIView()
    
    // tell the controller which view to use for left menu
    var leftMenu: UIView? {
        willSet {
            leftMenu?.removeFromSuperview()
        }
        didSet {
            if leftMenu != nil {
                scrollView.addSubview(leftMenu!)
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
//                setNeedsDisplayInRect(rightRect)
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
                mainView!.frame = mainContainerView.bounds // fill
            }
        }
    }
    
    var tap: UITapGestureRecognizer?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //configure scrollView
        scrollView.scrollEnabled = false
        scrollView.bounces = false
        scrollView.pagingEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1
        
        //add scrollview to view
        addSubview(scrollView)
        
        // add container to scrollView
        scrollView.addSubview(mainContainerView)
        
        // configure gestures
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: "leftSwipe")
        leftSwipe.direction = .Left
        addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: "rightSwipe")
        rightSwipe.direction = .Right
        addGestureRecognizer(rightSwipe)
        
        self.tap = UITapGestureRecognizer(target: self, action: "mainViewTap")
//        tap.cancelsTouchesInView = false //allow taps to continue to propigate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // make the scrollView fill up the screen
        scrollView.frame = bounds
        
        print("self frame:", frame, "bounds: ", bounds)
        
        //make the scroll view's total content area be the full screen plus the left and right menus
        let scrollViewSize = CGSize(width: screenSize.width + 2*menuWidth, height: screenSize.height)
        scrollView.contentSize = scrollViewSize
        
        print("scrollview frame: ", scrollView.frame, "contentSize: ", scrollView.contentSize)
        
        //set the scroll view's starting point to the main content
        scrollView.contentOffset = mainOrigin
        
        //make the main view fill up the whole screen
        mainContainerView.frame = CGRect(origin: mainOrigin, size: screenSize)
        
        print("main frame: ", mainContainerView.frame, "subviews: ", mainContainerView.subviews.map { v in "\(v.description): \(v.frame)" })
        
        if leftMenu != nil {
            //make the left menu fill the correct space
            leftMenu!.frame = CGRect(origin: leftOrigin, size: menuSize)
        }
        
        if rightMenu != nil {
            //make the left menu fill the correct space
            rightMenu!.frame = CGRect(origin: rightOrigin, size: menuSize)
        }
        
        scrollView.backgroundColor = UIColor.redColor()
        mainContainerView.backgroundColor = UIColor.blueColor()
    }
    
    // MARK: math
    
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
        return CGPoint(x: scrollView.contentSize.width - bounds.width, y: 0)
    }
    
    // the total visible screen size
    private var screenSize: CGSize {
        return bounds.size
    }
    
    private var menuSize: CGSize {
        return CGSize(width: menuWidth, height: screenSize.height)
    }
    
    private var leftRect: CGRect {
        return CGRect(origin: leftOrigin, size: screenSize)
    }
    
    private var rightRect: CGRect {
        return CGRect(origin: rightOrigin, size: screenSize)
    }
    
    // MARK: menu control
    
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
            scrollView.scrollRectToVisible(leftRect, animated: animated)
            mainContainerView.addGestureRecognizer(tap!)
        }
    }
    
    func openRightMenu(){
        if rightMenu != nil {
            scrollView.scrollRectToVisible(rightRect, animated: animated)
            mainContainerView.addGestureRecognizer(tap!)
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
        if tap != nil {
            mainContainerView.removeGestureRecognizer(tap!)
        }
    }
    
    // MARK: gesture listeners
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
    
    static func parentMenuContainer(viewController: UIViewController) -> MenuContainerView? {
        var vc: UIViewController? = viewController
        while vc != nil {
            if let menu = vc!.view as? MenuContainerView {
                return menu
            }else{
                vc = vc?.parentViewController
            }
        }
        return nil
    }
}

extension UIView {
    private func clearSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}