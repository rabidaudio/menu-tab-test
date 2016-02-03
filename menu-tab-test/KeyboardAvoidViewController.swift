//
//  KeyboardAvoidViewController.swift
//  menu-tab-test
//
//  Created by fixd on 2/3/16.
//  Copyright © 2016 fixd. All rights reserved.
//

import UIKit

class KeyboardAvoidViewController: UIViewController {
    
    var scrollView: UIScrollView {
        guard let sv = view as? UIScrollView else {
            fatalError("Need to make root view of KeyboardAvoidViewController a UIScrollView!")
        }
        return sv
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //double height for keyboard should be more than enough
//        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: 2*scrollView.bounds.height)
        scrollView.scrollEnabled = false
        scrollView.pagingEnabled = false
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tap"))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
            print("keyboard height", keyboardHeight, "view height", view.bounds.height, keyboardHeight/view.bounds.height)
            scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: scrollView.bounds.height + keyboardHeight)
//            let newRect = CGRect(origin: CGPoint(x: 0, y: keyboardHeight/2), size: scrollView.bounds.size)
            if let centerView = selectedView {
                // the new origin to scroll to is the one which centers the selected view in the space above the keyboard
                // to find this offset, we take the y position of the view and subtract the y position of the new center point
                let newCenter = (scrollView.bounds.height - keyboardHeight)/2
                let viewCenter = centerView.center.y
                let newOrigin = CGPoint(x: 0, y: viewCenter - newCenter)
                let newRect = CGRect(origin: newOrigin, size: scrollView.bounds.size)
                scrollView.scrollRectToVisible(newRect, animated: true)
            }
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        print("new bounds", scrollView.bounds)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("will hide", scrollView.bounds)
        scrollView.contentSize = scrollView.bounds.size
        scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: 0, y: 0), size: view.bounds.size), animated: true)
    }
    
    func tap() {
        //resign first responder so the keyboard will close
        selectedView?.resignFirstResponder()
    }
    
    private var selectedView: UIView? {
        for subview in view.subviews {
            if subview.isFirstResponder() {
                return subview
            }
        }
        return nil
    }
}
