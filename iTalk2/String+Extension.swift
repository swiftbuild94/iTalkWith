//
//  String+Extension.swift
//  iTalk
//
//  Created by Patricio Benavente on 27/09/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//
// Usage:
// if !email.isEmail {
//      self.errorMessage = "Please enter a valid email"
//      return
//  }

import Foundation
import UIKit

let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)

extension String {
    func isEmail() -> Bool {
        return __emailPredicate.evaluate(with: self)
    }
}

extension UITextField {
    func isEmail() -> Bool {
        return self.text?.isEmail() ?? false
    }
}

let phonePattern = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
extension String {
    func isPhone() -> Bool {
     let result = self.range(
            of: phonePattern,
            options: .regularExpression
        )
        let validPhoneNumber = (result != nil)
        return validPhoneNumber
    }
}

extension UITextField {
    func isPhone() -> Bool {
        return self.text?.isPhone() ?? false
    }
}
