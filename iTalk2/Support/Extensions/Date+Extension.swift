//
//  Date+toString.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 19/04/2022.
//

import Foundation

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

