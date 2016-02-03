//
//  MenuContainerView.swift
//  menu-tab-test
//
//  Created by @charlesjuliank on 2/2/16.
//

import UIKit

// This is a special view where you can set a mainView as well as left and right menu views.
// It enables gesture-based opening and closing by properly sizing a scroll view and handling
// scroll position for you. If you only want a menu on one side, simply leave the other side
// unset and the view won't show it (even if you ask).
//
// You can size the menus as a percentage of the screen using menuWidthPercentage.
//
// One neat trick is to set the class of a top level view in a viewController to this class,
// and then populate the menus as necessary in the controller. You can populate it in two ways:
//
//  In code:
//   - instantiate a view controller using storyboard!.instantiateViewControllerWithIdentifier()
//   - add that controller as a child using addChildViewController()
//   - set the menu view (leftMenu, rightMenu, or mainView) to the controller's view
//
//  In storyboard:     (theoretically, but will require changes with convertExistingViews() to get to work)
//   - set the main view of the controller to be a MenuContainerView. Add 1-3 container views to
//      it and size them however you like (they will be resized correctly at instantiation)
//   - tag these container views like so: 0 for mainView, 1 for leftMenu, 2 for rightMenu
//   - create an 'embed' relationship segue from the container to the controller you want
//
//
// Using scroll view and child view controllers this way allows us to wrap ANY view controller in
// a menu, even UITabBarControllers.
//
// Wrapping this view's controller in a NavigationController allows you to use the same navigation
// across all your child controllers (so if your nav bar needs to open/close menus, you only have
// to code that once). Unfortunately, this also means that the navigation bar will be on top of your
// menus, which you probably don't want. One way to accomplish this is to simply make one more in-between
// view controller with a navigation bar and a content view that points to your next controller.
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
    
//    private func convertExistingViews() {
//        // this shold work in theory, but for some reason child bounds are set to 0 after they are re-added
//        if !subviews.isEmpty {
//            //remove all the subviews so they can be re-added correctly
//            var newMain: UIView?
//            var newLeft: UIView?
//            var newRight: UIView?
//            for subview in subviews {
//                // we use defer here because we want to make sure the other views are prepeared correctly first
//                switch subview.tag {
//                case 0: // main view
//                    newMain = subview
//                case 1:
//                    newLeft = subview
//                case 2:
//                    newRight = subview
//                default:
//                    break // let it get removed
//                }
//            }
//            dispatch_async(dispatch_get_main_queue(), {
//                self.mainView = newMain
//                self.leftMenu = newLeft
//                self.rightMenu = newRight
//            })
//            clearSubviews()
//        }
//    }
    
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
        return CGPoint(x: scrollView.contentSize.width - menuWidth, y: 0)
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