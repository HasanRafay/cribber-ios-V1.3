//
//  SignupViewController.swift
//  Cribber
//
//  Created by Tim Ross on 25/03/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignupViewController: UIViewController, PhoneNumberFieldDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var phoneNumberTextField: PhoneNumberField!
    @IBOutlet weak var sendVerificationButton: UIButton!
    @IBOutlet weak var prefixPickerView: UIPickerView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var authenticationManager: AuthenticationManager!
    var phoneNumberHelper: PhoneNumberHelper!
    
    var keyboardHeight = CGFloat(0)
    
    lazy var countryList: [Country] = {
        return Country.all
    }()
    
    var defaultCountryIndex: Int {
        let countryLocale = NSLocale.currentLocale()
        let countryCode = countryLocale.objectForKey(NSLocaleCountryCode) as! String
        for (index, country) in countryList.enumerate() {
            if country.code == countryCode {
                return index
            }
        }
        return 0
    }
    
    var selectedCountry: Country {
        let selectedRow = prefixPickerView.selectedRowInComponent(0)
        return countryList[selectedRow]
    }
    
    func validatePhoneNumber() -> Bool {
        var isValidPhoneNumber = false
        if let phoneNumber = phoneNumberTextField.phoneNumber {
            isValidPhoneNumber = phoneNumberHelper.isValidPhoneNumber(phoneNumber.description)
        }
        phoneNumberTextField.displayIsValid(isValidPhoneNumber)
        return isValidPhoneNumber
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticationManager = AuthenticationManager.sharedInstance
        phoneNumberHelper = PhoneNumberHelper()
        
        // Set selected country based on users locale
        let countryIndex = defaultCountryIndex
        prefixPickerView.selectRow(countryIndex, inComponent: 0, animated: false)
        pickerView(prefixPickerView, didSelectRow: countryIndex, inComponent: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(SignupViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        phoneNumberTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        AnalyticsManager.sharedInstance.sendScreenView("Sign up")
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "verifySegue" {
            let controller = segue.destinationViewController as! VerifyViewController
            controller.phoneNumber = phoneNumberTextField.phoneNumber
        }
    }
    
    @IBAction func signup(sender: UIButton) {
        if !validatePhoneNumber() {
            return;
        }
        sender.enabled = false
        SVProgressHUD.show()
        authenticationManager.signin(phoneNumberTextField.phoneNumber!, completion: {
            error in
            SVProgressHUD.dismiss()
            sender.enabled = true
            if error != nil {
                self.showErrorAlert(error!)
            } else {
                self.performSegueWithIdentifier("verifySegue", sender: self)
            }
        })
    }
    
    func fadeInPrefixPicker() {
        prefixPickerView.hidden = false
        prefixPickerView.alpha = 0
        UIView.animateWithDuration(0.3, animations: {
            self.prefixPickerView.alpha = 1.0
            return
        })
    }
    
    func fadeOutPrefixPicker() {
        UIView.animateWithDuration(0.3, animations: {
            self.prefixPickerView.alpha = 0
            return
            }, completion: {
                (value: Bool) in
                self.prefixPickerView.hidden = true
                return
            }
        )
    }
    
    func phoneNumberFieldDidSelectChangePrefix(field: PhoneNumberField!) {
        if (self.prefixPickerView.hidden) {
            field.resignFirstResponder()
            fadeInPrefixPicker()
        } else {
            phoneNumberTextField.becomeFirstResponder()
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let country = countryList[row]
        return "\(country.name) (+\(country.prefix))"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let country = countryList[row]
        phoneNumberTextField.prefixLabel = "+\(country.prefix)"
        phoneNumberHelper.countryCode = country.code
        phoneNumberTextField.clearValidation()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        fadeOutPrefixPicker()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        if !phoneNumberHelper.isValidInput(string) {
            return false
        }
        
        if newText.characters.count > phoneNumberHelper.maxPhoneNumberLength {
            return false
        }
        
        phoneNumberTextField.text = newText
        
        let isValidPhoneNumber = validatePhoneNumber()
        if !isValidPhoneNumber {
            // Remove error validation while typing
            phoneNumberTextField.clearValidation()
        }
        
        return false;
    }
}
