//
//  Collection+extansions.swift
//  DZRacing
//
//  Created by алексей ганзицкий on 21.07.2022.
//

import Foundation
import UIKit

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
