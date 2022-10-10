//
//  keyBoardHelper.swift
//  BioAuth
//
//  Created by Tejas Ardeshna on 03/11/17.
//  Copyright © 2017 Tejas Ardeshna. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissingKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissingKeyboard()
    {
        view.endEditing(true)
    }
}
