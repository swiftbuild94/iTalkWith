//
//  Array+Extension.swift
//  iTalk
//
//  Created by Patricio Benavente on 27/09/20.
//  Copyright © 2020 Patricio Benavente. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
	func firstIndex(matching: Element) -> Int? {
		for index in 0..<self.count {
			if self[index].id == matching.id {
				return index
			}
		}
		return nil
	}
}
