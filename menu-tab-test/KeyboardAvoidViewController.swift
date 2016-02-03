//
//  KeyboardAvoidViewController.swift
//  menu-tab-test
//
//  Created by @charlesjuliank on 2/3/16.
//

import UIKit

// This is a pretty easy to use ViewController for allowing views to move into screen when the keyboard shows.
// Simply set your view controller class to this or a subclass, and set the class of the top-level view of
// the controller to a UIScrollView. No other changes are necessary. This will slide the currently focused
// view to be in the center of the remaining screen space. It handles changing focus and auto-closing the keyboard
// when leaving focus. It also correctly handles hardware keyboards like in the emulator (that is, it does nothing).
class KeyboardAvoidViewController: UIViewController {
    
    var scrollView: UIScrollView {
        guard let sv = view as? UIScrollView else {
            fatalError("Need to make root view of KeyboardAvoidViewController a UIScrollView!")
        }
        return sv
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make scrollView uninteractable
        scrollView.scrollEnabled = false
        scrollView.pagingEnabled = false
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1
        
        // listen for taps to close keyboard
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tap"))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
            scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: scrollView.bounds.height + keyboardHeight)
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
    
    func keyboardWillHide(notification: NSNotification) {
        // reset by chaning the scrollView's content size back to normal
        scrollView.contentSize = scrollView.bounds.size
        scrollView.scrollRectToVisible(scrollView.bounds, animated: true)
    }
    
    func tap() {
        selectedView?.resignFirstResponder() //resign first responder so the keyboard will close
    }
    
    // find the currently selectedview
    private var selectedView: UIView? {
        for subview in view.subviews {
            if subview.isFirstResponder() {
                return subview
            }
        }
        return nil
    }
}
