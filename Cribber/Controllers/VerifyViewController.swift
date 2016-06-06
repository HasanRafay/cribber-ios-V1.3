//
//  VerifyViewController.swift
//  Cribber
//
//  Created by Tim Ross on 25/03/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import HTTPStatusCodes

class VerifyViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var verifyTextField: ValidatedTextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var authenticationManager: AuthenticationManager!
    var phoneNumber: PhoneNumber?
    
    var keyboardHeight = CGFloat(0)
    
    func validateCodeRequired() -> Bool {
        let isValidCode = verifyTextField.text!.characters.count > 0
        if isValidCode {
            verifyTextField.clearValidation()
        }
        else {
            verifyTextField.displayIsValid(false)
        }
        return isValidCode
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticationManager = AuthenticationManager.sharedInstance
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(VerifyViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        verifyTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        AnalyticsManager.sharedInstance.sendScreenView("Verify")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        view.endEditing(true)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        keyboardHeight = SignupFormHelper.keyboardHeightFromUserInfo(sender.userInfo!)
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        let offset = SignupFormHelper.offsetForOrientation()
        self.bottomConstraint.constant = keyboardHeight + offset
        super.updateViewConstraints()
    }
    
    @IBAction func verify(sender: UIButton) {
        if !validateCodeRequired() {
            return;
        }
        sender.enabled = false
        SVProgressHUD.show()
        authenticationManager.verify(phoneNumber!, code: verifyTextField.text!, completion: {
            (isAuthenticated, error) in
            SVProgressHUD.dismiss()
            sender.enabled = true
            if error != nil {
                if error!.code == HTTPStatusCode.Unauthorized.rawValue {
                    self.verifyTextField.displayIsValid(false)
                }
                self.showErrorAlert(error!)
            } else if isAuthenticated {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        if newText.characters.count > 4 {
            return false
        }
        
        verifyTextField.clearValidation()
        
        return true;
    }
}
