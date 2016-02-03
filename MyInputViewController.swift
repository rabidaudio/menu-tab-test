//
//  MyInputViewController.swift
//  menu-tab-test
//
//  Created by fixd on 2/3/16.
//  Copyright © 2016 fixd. All rights reserved.
//

import UIKit

class MyInputViewController: KeyboardAvoidViewController {
    
    
    @IBAction func hopToNextInput(sender: UITextField) {
        nextTextView(sender)?.becomeFirstResponder()
    }
    
    @IBAction func submit(sender: AnyObject) {
        performSegueWithIdentifier("continue", sender: self)
    }
    
    private func nextTextView(current: UITextField) -> UITextField? {
        var isNext = false
        for subview in view.subviews {
            if subview == current {
                isNext = true
            } else if isNext {
                if let textView = subview as? UITextField {
                    return textView
                }
            }
        }
        return nil
    }
}
