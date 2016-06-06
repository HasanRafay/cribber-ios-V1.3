//
//  PhoneNumberHelper.swift
//  Cribber
//
//  Created by Tim Ross on 27/04/15.
//  Copyright (c) 2015 Skirr Pty Ltd. All rights reserved.
//

import Foundation
import libPhoneNumber_iOS

class PhoneNumberHelper {
    
    let phoneNumberUtil: NBPhoneNumberUtil
    
    var maxPhoneNumberLength: Int {
        return 16
    }
    
    var countryCode: String?
    
    init() {
        phoneNumberUtil = NBPhoneNumberUtil()
    }
    
    func isValidInput(input: String) -> Bool {
        let validInputCharacterSet = NSCharacterSet(charactersInString: "0123456789 ")
        let invalidInputCharacterSet = validInputCharacterSet.invertedSet
        let rangeOfInvalidCharacters = input.rangeOfCharacterFromSet(invalidInputCharacterSet)
        return rangeOfInvalidCharacters == nil
    }
    
    func isValidPhoneNumber(input: String) -> Bool {
        if let phoneNumber = phoneNumberFromString(input) {
            assert(countryCode != nil, "Country code cannot be nil when validating phone number")
            let numberType = phoneNumberUtil.getNumberType(phoneNumber)
            let isValidType = numberType == NBEPhoneNumberTypeMOBILE || numberType == NBEPhoneNumberTypeFIXED_LINE_OR_MOBILE
            let isValidNumber = phoneNumberUtil.isValidNumberForRegion(phoneNumber, regionCode: countryCode)
            return isValidType && isValidNumber
        }
        return false
    }
    
    private func phoneNumberFromString(input: String) -> NBPhoneNumber? {
        do {
            return try phoneNumberUtil.parse(input, defaultRegion: countryCode)
        } catch let error as NSError {
            Log.Error("Parsing phone number", error: error)
            return nil
        }
    }
}
