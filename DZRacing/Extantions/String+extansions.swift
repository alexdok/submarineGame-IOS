//
//  String+extansions.swift
//  DZRacing
//
//  Created by алексей ганзицкий on 23.11.2022.
//

import Foundation

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
